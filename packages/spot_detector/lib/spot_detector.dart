import 'dart:ffi';
import 'dart:io' show File, Platform;
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

/// 单个亮斑：归一化 (0~1) 坐标 + 峰值亮度。
class NativeSpot {
  const NativeSpot({
    required this.x0,
    required this.y0,
    required this.x1,
    required this.y1,
    required this.peak,
  });

  final double x0;
  final double y0;
  final double x1;
  final double y1;
  final double peak;
}

/// 一次检测的输出：亮斑列表 + 降采样亮度网格（供 UI 放大镜）。
class NativeSpotResult {
  const NativeSpotResult({
    required this.spots,
    required this.grid,
    required this.gridWidth,
    required this.gridHeight,
  });

  final List<NativeSpot> spots;
  final Float32List grid;
  final int gridWidth;
  final int gridHeight;
}

/// 亮斑个数上限（实际远低于此，超出的会被截断）。
const _maxSpots = 64;

typedef _SdDetectNative = Int32 Function(
  Pointer<Uint8> yPlane,
  Int32 width,
  Int32 height,
  Int32 rowStride,
  Int32 step,
  Float sensitivity,
  Float minCircularity,
  Int32 minSize,
  Float maxSize,
  Pointer<Float> spotsOut,
  Int32 spotsCapacity,
  Pointer<Int32> spotsCount,
  Pointer<Float> gridOut,
  Pointer<Int32> gridWidth,
  Pointer<Int32> gridHeight,
);

typedef _SdDetectDart = int Function(
  Pointer<Uint8> yPlane,
  int width,
  int height,
  int rowStride,
  int step,
  double sensitivity,
  double minCircularity,
  int minSize,
  double maxSize,
  Pointer<Float> spotsOut,
  int spotsCapacity,
  Pointer<Int32> spotsCount,
  Pointer<Float> gridOut,
  Pointer<Int32> gridWidth,
  Pointer<Int32> gridHeight,
);

/// FFI 检测内核入口。加载失败时 [available] 为 false，调用方回退 Dart 实现。
class NativeSpotDetector {
  NativeSpotDetector._(this._detect);

  final _SdDetectDart _detect;

  static NativeSpotDetector? _instance;

  static NativeSpotDetector get instance => _instance ??= _tryLoad();

  static NativeSpotDetector _tryLoad() {
    try {
      final lib = _openLibrary();
      final detect =
          lib.lookupFunction<_SdDetectNative, _SdDetectDart>('sd_detect');
      return NativeSpotDetector._(detect);
    } catch (_) {
      return NativeSpotDetector._(_intFunctionFallback);
    }
  }

  static DynamicLibrary _openLibrary() {
    if (Platform.isAndroid) {
      return DynamicLibrary.open('libspot_detector.so');
    }
    if (Platform.isIOS) {
      // iOS 上插件的 C 内核被构建为嵌入 App 的动态 framework，
      // 通过主可执行文件路径推导出 framework 位置后 dlopen。
      try {
        final exe = File(Platform.resolvedExecutable);
        final bundle = exe.parent.parent.path;
        final frameworkPath = '$bundle/Frameworks'
            '/spot_detector.framework/spot_detector';
        if (File(frameworkPath).existsSync()) {
          return DynamicLibrary.open(frameworkPath);
        }
      } catch (_) {}
    }
    return DynamicLibrary.process();
  }

  /// 兜底实现：直接返回 0 个亮点，调用方会回退到 Dart 算法。
  static int _intFunctionFallback(
    Pointer<Uint8> yPlane,
    int width,
    int height,
    int rowStride,
    int step,
    double sensitivity,
    double minCircularity,
    int minSize,
    double maxSize,
    Pointer<Float> spotsOut,
    int spotsCapacity,
    Pointer<Int32> spotsCount,
    Pointer<Float> gridOut,
    Pointer<Int32> gridWidth,
    Pointer<Int32> gridHeight,
  ) {
    return 0;
  }

  bool get available => _detect != _intFunctionFallback;

  /// 对 Y 平面执行亮斑检测。返回 null 表示输入网格过小或内存失败。
  NativeSpotResult? detect(
    Uint8List yPlane,
    int width,
    int height,
    int rowStride, {
    int step = 8,
    double sensitivity = 3.0,
    double minCircularity = 0.5,
    int minSize = 2,
    double maxSize = double.infinity,
  }) {
    final gx = width ~/ step;
    final gy = height ~/ step;
    if (gx < 8 || gy < 8) return null;

    final yPtr = calloc<Uint8>(yPlane.length);
    final spotsOut = calloc<Float>(_maxSpots * 5);
    final gridOut = calloc<Float>(gx * gy);
    final spotsCount = calloc<Int32>(1);
    final gridWidth = calloc<Int32>(1);
    final gridHeight = calloc<Int32>(1);
    try {
      yPtr.asTypedList(yPlane.length).setAll(0, yPlane);
      final count = _detect(
        yPtr,
        width,
        height,
        rowStride,
        step,
        sensitivity,
        minCircularity,
        minSize,
        maxSize,
        spotsOut,
        _maxSpots,
        spotsCount,
        gridOut,
        gridWidth,
        gridHeight,
      );
      if (count < 0) return null;

      final n = count.clamp(0, _maxSpots);
      final spots = <NativeSpot>[];
      final vals = spotsOut.asTypedList(n * 5);
      for (var i = 0; i < n; i++) {
        final base = i * 5;
        spots.add(NativeSpot(
          x0: vals[base],
          y0: vals[base + 1],
          x1: vals[base + 2],
          y1: vals[base + 3],
          peak: vals[base + 4],
        ));
      }
      final gw = gridWidth.value;
      final gh = gridHeight.value;
      final grid = gw > 0 && gh > 0
          ? Float32List.fromList(gridOut.asTypedList(gw * gh))
          : Float32List(0);
      return NativeSpotResult(
        spots: spots,
        grid: grid,
        gridWidth: gw,
        gridHeight: gh,
      );
    } finally {
      calloc.free(yPtr);
      calloc.free(spotsOut);
      calloc.free(gridOut);
      calloc.free(spotsCount);
      calloc.free(gridWidth);
      calloc.free(gridHeight);
    }
  }
}
