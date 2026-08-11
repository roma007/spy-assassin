#ifndef SPOT_DETECTOR_H
#define SPOT_DETECTOR_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/// 红外/反光亮斑检测内核（与 Dart 版算法一致）。
///
/// 在 YUV420 的 Y 平面上做降采样网格 → 均值阈值 → 连通域 BFS → 尺寸/圆度过滤。
/// 输出归一化 (0~1) 坐标的亮点矩形，供上层叠加框选与放大镜绘制。
///
/// [y_plane] Y 平面起始地址；[width]/[height] 平面尺寸；[row_stride] 每行字节数。
/// [step] 降采样步长；[sensitivity] 阈值系数；[min_circularity] 圆度下限；
/// [min_size]/[max_size] 亮点面积（网格格数）过滤。
///
/// [spots_out] 预分配的浮点缓冲区，每个亮点占 5 个 float：
///   x0, y0, x1, y1, peak（前四个为归一化 0~1）。
/// [spots_capacity] 缓冲能容纳的亮点个数上限；[spots_count] 输出实际个数。
/// [grid_out] 可空，非空时输出降采样亮度网格（gx*gy 个 float）；
/// [grid_width]/[grid_height] 输出网格尺寸，网格过小时为 0。
///
/// 返回亮点个数（可能被 capacity 截断），网格过小返回 0，内存失败返回 -1。
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
    int32_t* grid_height);

#ifdef __cplusplus
}
#endif

#endif
