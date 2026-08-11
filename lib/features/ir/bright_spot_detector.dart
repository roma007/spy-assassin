import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:spot_detector/spot_detector.dart';

/// 红外亮斑检测：在 YUV 的 Y（亮度）平面上找高亮连通区域。
///
/// 原理：夜视摄像头在黑暗环境中开启红外补光，红外光在手机
/// CMOS 上呈现为明显亮于背景的亮点。这里用降采样 + 阈值 +
/// 连通域合并完成检测；优先走 C 内核（FFI，双端共享，帧率更高），
/// 原生库不可用时回退到 Dart 实现（M1 原型算法）。
class BrightSpot {
  const BrightSpot({
    required this.rect,
    required this.peakIntensity,
  });

  /// 归一化坐标（0~1，相对相机画面）。
  final Rect rect;
  final double peakIntensity;
}

class BrightSpotDetector {
  BrightSpotDetector({
    this.sensitivity = 3.0,
    this.minCircularity = 0.5,
    this.minSize = 2,
    this.maxSize = double.infinity,
  });

  /// 阈值系数：亮点亮度需超过环境均值 × sensitivity。
  final double sensitivity;

  /// 圆度下限（4π·面积/周长²），圆形亮点接近 1，细长眩光明显偏低。
  /// 红外默认 0.5；镜头反光更严苛，使用 0.6。
  final double minCircularity;

  /// 亮点最小面积（网格格数），低于此面积视为噪点。
  final int minSize;

  /// 亮点最大面积（网格格数），整片高亮/大面积反光会被忽略。
  final double maxSize;

  /// 采样步长（越大越快，越小越精细）。
  static const _step = 8;

  /// 最近一帧的降采样亮度网格，供 UI 放大镜绘制。
  Float32List? lastGrid;
  int gridWidth = 0;
  int gridHeight = 0;

  List<BrightSpot> detect(CameraImage image) {
    final plane = image.planes[0];
    final bytes = plane.bytes;
    final width = plane.width ?? image.width;
    final height = plane.height ?? image.height;
    final rowStride = plane.bytesPerRow;

    final native = NativeSpotDetector.instance;
    if (native.available) {
      final result = native.detect(
        bytes,
        width,
        height,
        rowStride,
        step: _step,
        sensitivity: sensitivity,
        minCircularity: minCircularity,
        minSize: minSize,
        maxSize: maxSize,
      );
      if (result != null) {
        lastGrid = result.grid;
        gridWidth = result.gridWidth;
        gridHeight = result.gridHeight;
        return [
          for (final s in result.spots)
            BrightSpot(
              rect: Rect.fromLTRB(s.x0, s.y0, s.x1, s.y1),
              peakIntensity: s.peak,
            ),
        ];
      }
      lastGrid = null;
      gridWidth = 0;
      gridHeight = 0;
      return [];
    }
    return _detectDart(bytes, width, height, rowStride);
  }

  /// Dart 回退实现（与 C 内核算法一致）。
  List<BrightSpot> _detectDart(
      Uint8List bytes, int width, int height, int rowStride) {
    final gx = width ~/ _step;
    final gy = height ~/ _step;
    if (gx < 8 || gy < 8) {
      lastGrid = null;
      return [];
    }

    // 1. 降采样建网格
    final grid = Float32List(gx * gy);
    double sum = 0;
    var i = 0;
    for (var y = 0; y < gy; y++) {
      final rowOffset = y * _step * rowStride;
      for (var x = 0; x < gx; x++) {
        final v = bytes[rowOffset + x * _step].toDouble();
        grid[i] = v;
        sum += v;
        i++;
      }
    }

    lastGrid = grid;
    gridWidth = gx;
    gridHeight = gy;

    final mean = sum / (gx * gy);
    final threshold = (mean * sensitivity).clamp(140.0, 255.0);

    // 2. 标记热点
    final hot = Uint8List(gx * gy);
    for (var j = 0; j < hot.length; j++) {
      if (grid[j] > threshold) hot[j] = 1;
    }

    // 3. 连通域合并（扫描线式 flood fill）
    final spots = <BrightSpot>[];
    final visited = Uint8List(gx * gy);
    for (var y = 0; y < gy; y++) {
      for (var x = 0; x < gx; x++) {
        final idx = y * gx + x;
        if (hot[idx] == 0 || visited[idx] == 1) continue;

        // BFS
        var minX = x, maxX = x, minY = y, maxY = y;
        var count = 0;
        var perimeter = 0;
        double peak = 0;
        final queue = <int>[idx];
        visited[idx] = 1;
        while (queue.isNotEmpty) {
          final cur = queue.removeLast();
          final cx = cur % gx;
          final cy = cur ~/ gx;
          count++;
          if (grid[cur] > peak) peak = grid[cur];
          if (cx < minX) minX = cx;
          if (cx > maxX) maxX = cx;
          if (cy < minY) minY = cy;
          if (cy > maxY) maxY = cy;

          for (final (dx, dy) in const [
            (-1, 0),
            (1, 0),
            (0, -1),
            (0, 1),
          ]) {
            final nx = cx + dx;
            final ny = cy + dy;
            if (nx < 0 || nx >= gx || ny < 0 || ny >= gy) {
              perimeter++;
              continue;
            }
            final ni = ny * gx + nx;
            if (hot[ni] == 1) {
              if (visited[ni] == 0) {
                visited[ni] = 1;
                queue.add(ni);
              }
            } else {
              perimeter++;
            }
          }
        }

        // 4. 过滤：面积过小忽略，过大（整片高亮）忽略；细长光斑（反光/眩光）忽略
        final w = (maxX - minX + 1).toDouble();
        final h = (maxY - minY + 1).toDouble();
        if (count < minSize || w < 1.5 || h < 1.5) continue;
        if (w > gx * 0.4 || h > gy * 0.4) continue;
        if (count > maxSize) continue;
        // 圆度 = 4π·面积/周长²，圆形亮点接近 1，细长眩光明显偏低
        if (perimeter > 0 && 4 * pi * count / (perimeter * perimeter) < minCircularity) {
          continue;
        }

        spots.add(BrightSpot(
          rect: Rect.fromLTRB(
            minX / gx,
            minY / gy,
            (maxX + 1) / gx,
            (maxY + 1) / gy,
          ),
          peakIntensity: peak,
        ));
      }
    }
    return spots;
  }
}
