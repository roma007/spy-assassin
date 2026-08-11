#include "spot_detector.h"

#include <math.h>
#include <stdlib.h>
#include <string.h>

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

int32_t sd_detect(
    const uint8_t* y_plane,
    int32_t width,
    int32_t height,
    int32_t row_stride,
    int32_t step,
    float sensitivity,
    float min_circularity,
    int32_t min_size,
    float max_size,
    float* spots_out,
    int32_t spots_capacity,
    int32_t* spots_count,
    float* grid_out,
    int32_t* grid_width,
    int32_t* grid_height) {
  if (spots_count) *spots_count = 0;
  if (step < 1) step = 1;

  const int32_t gx = width / step;
  const int32_t gy = height / step;
  if (gx < 8 || gy < 8 || y_plane == NULL) {
    if (grid_width) *grid_width = 0;
    if (grid_height) *grid_height = 0;
    return 0;
  }
  if (grid_width) *grid_width = gx;
  if (grid_height) *grid_height = gy;

  float* grid = (float*)malloc((size_t)gx * (size_t)gy * sizeof(float));
  uint8_t* hot = (uint8_t*)malloc((size_t)gx * (size_t)gy);
  uint8_t* visited = (uint8_t*)malloc((size_t)gx * (size_t)gy);
  int32_t* queue = (int32_t*)malloc((size_t)gx * (size_t)gy * sizeof(int32_t));
  if (!grid || !hot || !visited || !queue) {
    free(grid);
    free(hot);
    free(visited);
    free(queue);
    return -1;
  }

  // 1. 降采样建网格
  double sum = 0;
  for (int32_t y = 0; y < gy; y++) {
    const uint8_t* row = y_plane + (int64_t)y * step * row_stride;
    float* g = grid + (int64_t)y * gx;
    for (int32_t x = 0; x < gx; x++) {
      const float v = (float)row[(int64_t)x * step];
      g[x] = v;
      sum += v;
    }
  }

  if (grid_out) {
    memcpy(grid_out, grid, (size_t)gx * (size_t)gy * sizeof(float));
  }

  // 2. 阈值 = clamp(均值 * 灵敏度, 140, 255)
  const double mean = sum / (double)((int64_t)gx * gy);
  double th = mean * sensitivity;
  if (th < 140.0) th = 140.0;
  if (th > 255.0) th = 255.0;

  const int32_t total = gx * gy;
  for (int32_t i = 0; i < total; i++) {
    hot[i] = grid[i] > th ? 1 : 0;
    visited[i] = 0;
  }

  // 3. 连通域合并（迭代式 BFS）+ 过滤
  int32_t count = 0;
  for (int32_t y = 0; y < gy; y++) {
    for (int32_t x = 0; x < gx; x++) {
      const int32_t idx = y * gx + x;
      if (!hot[idx] || visited[idx]) continue;

      int32_t qhead = 0, qtail = 0;
      queue[qtail++] = idx;
      visited[idx] = 1;

      int32_t minX = x, maxX = x, minY = y, maxY = y;
      int32_t cell_count = 0;
      int32_t perimeter = 0;
      float peak = 0;

      while (qhead < qtail) {
        const int32_t cur = queue[qhead++];
        const int32_t cx = cur % gx;
        const int32_t cy = cur / gx;
        cell_count++;
        if (grid[cur] > peak) peak = grid[cur];
        if (cx < minX) minX = cx;
        if (cx > maxX) maxX = cx;
        if (cy < minY) minY = cy;
        if (cy > maxY) maxY = cy;

        static const int dxs[4] = {-1, 1, 0, 0};
        static const int dys[4] = {0, 0, -1, 1};
        for (int k = 0; k < 4; k++) {
          const int32_t nx = cx + dxs[k];
          const int32_t ny = cy + dys[k];
          if (nx < 0 || nx >= gx || ny < 0 || ny >= gy) {
            perimeter++;
            continue;
          }
          const int32_t ni = ny * gx + nx;
          if (hot[ni]) {
            if (!visited[ni]) {
              visited[ni] = 1;
              queue[qtail++] = ni;
            }
          } else {
            perimeter++;
          }
        }
      }

      // 4. 过滤：面积过小/整片高亮/细长眩光
      const int32_t w = maxX - minX + 1;
      const int32_t h = maxY - minY + 1;
      if (cell_count < min_size) continue;
      if ((double)w < 1.5 || (double)h < 1.5) continue;
      if (w > gx * 0.4 || h > gy * 0.4) continue;
      if (cell_count > max_size) continue;
      if (perimeter > 0) {
        const double circularity =
            4.0 * M_PI * cell_count / ((double)perimeter * perimeter);
        if (circularity < min_circularity) continue;
      }

      if (count < spots_capacity && spots_out) {
        float* s = spots_out + (int64_t)count * 5;
        s[0] = (float)minX / gx;
        s[1] = (float)minY / gy;
        s[2] = (float)(maxX + 1) / gx;
        s[3] = (float)(maxY + 1) / gy;
        s[4] = peak;
        count++;
      }
    }
  }

  free(grid);
  free(hot);
  free(visited);
  free(queue);
  if (spots_count) *spots_count = count;
  return count;
}
