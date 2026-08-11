import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:privacy_camera/features/ir/bright_spot_detector.dart';

CameraImage _yImage(Uint8List bytes, {int width = 640, int height = 480}) {
  return CameraImage.fromPlatformInterface(
    CameraImageData(
      format: const CameraImageFormat(ImageFormatGroup.yuv420, raw: 0),
      planes: [
        CameraImagePlane(
          bytes: bytes,
          bytesPerRow: width,
          width: width,
          height: height,
        ),
      ],
      width: width,
      height: height,
    ),
  );
}

Uint8List _darkFrame(int width, int height) {
  return Uint8List(width * height);
}

void main() {
  const width = 640;
  const height = 480;

  group('BrightSpotDetector 圆形亮斑', () {
    test('全黑画面无亮斑', () {
      final detector = BrightSpotDetector();
      final spots = detector.detect(_yImage(_darkFrame(width, height)));
      expect(spots, isEmpty);
    });

    test('圆形亮斑被检出且峰值正确', () {
      final bytes = _darkFrame(width, height);
      // 16x16 像素方块 → 2x2 网格格，圆度 0.785
      for (var y = 80; y < 96; y++) {
        for (var x = 80; x < 96; x++) {
          bytes[y * width + x] = 255;
        }
      }
      final detector = BrightSpotDetector();
      final spots = detector.detect(_yImage(bytes));
      expect(spots, hasLength(1));
      expect(spots.single.peakIntensity, 255);
      // 归一化坐标应落在左上象限
      expect(spots.single.rect.center.dx, lessThan(0.5));
      expect(spots.single.rect.center.dy, lessThan(0.5));
    });

    test('单个格点（面积过小）被忽略', () {
      final bytes = _darkFrame(width, height);
      bytes[80 * width + 80] = 255;
      final detector = BrightSpotDetector();
      expect(detector.detect(_yImage(bytes)), isEmpty);
    });

    test('细长眩光被圆度过滤', () {
      final bytes = _darkFrame(width, height);
      // 1 格高、20 格宽的长条（10*8=160 像素宽），圆度远低于 0.5
      for (var y = 64; y < 72; y++) {
        for (var x = 0; x < 160; x++) {
          bytes[y * width + x] = 255;
        }
      }
      final detector = BrightSpotDetector();
      expect(detector.detect(_yImage(bytes)), isEmpty);
    });

    test('整幅画面过亮被忽略', () {
      final bytes = Uint8List(width * height);
      bytes.fillRange(0, bytes.length, 255);
      final detector = BrightSpotDetector();
      expect(detector.detect(_yImage(bytes)), isEmpty);
    });

    test('多处亮斑均检出', () {
      final bytes = _darkFrame(width, height);
      for (var y = 80; y < 96; y++) {
        for (var x = 80; x < 96; x++) {
          bytes[y * width + x] = 255;
        }
        for (var x = 400; x < 416; x++) {
          bytes[y * width + x] = 255;
        }
      }
      final detector = BrightSpotDetector();
      expect(detector.detect(_yImage(bytes)), hasLength(2));
    });

    test('降采样网格已输出供放大镜使用', () {
      final detector = BrightSpotDetector();
      detector.detect(_yImage(_darkFrame(width, height)));
      expect(detector.lastGrid, isNotNull);
      expect(detector.gridWidth, width ~/ 8);
      expect(detector.gridHeight, height ~/ 8);
    });
  });

  group('BrightSpotDetector 可配置过滤参数', () {
    test('minCircularity 提高后拒绝低圆度光斑', () {
      // 2x6 格的长条（圆度≈0.59），默认 0.5 可通过，反光扫描 0.6 应拒绝
      final bytes = _darkFrame(width, height);
      for (var y = 64; y < 80; y++) {
        for (var x = 0; x < 48; x++) {
          bytes[y * width + x] = 255;
        }
      }
      expect(BrightSpotDetector().detect(_yImage(bytes)), hasLength(1));
      final strict = BrightSpotDetector(minCircularity: 0.6);
      expect(strict.detect(_yImage(bytes)), isEmpty);
    });

    test('maxSize 限制整片大面积光斑', () {
      final bytes = _darkFrame(width, height);
      // 4x4 格（面积 16）远大于 maxSize 4
      for (var y = 64; y < 96; y++) {
        for (var x = 0; x < 32; x++) {
          bytes[y * width + x] = 255;
        }
      }
      expect(BrightSpotDetector().detect(_yImage(bytes)), hasLength(1));
      final capped = BrightSpotDetector(maxSize: 4);
      expect(capped.detect(_yImage(bytes)), isEmpty);
    });

    test('minSize 忽略更小的噪点', () {
      final bytes = _darkFrame(width, height);
      // 2x2 格（面积 4）≥ 默认 minSize 2，会被检出
      for (var y = 64; y < 80; y++) {
        for (var x = 0; x < 16; x++) {
          bytes[y * width + x] = 255;
        }
      }
      expect(BrightSpotDetector().detect(_yImage(bytes)), hasLength(1));
      final strict = BrightSpotDetector(minSize: 8);
      expect(strict.detect(_yImage(bytes)), isEmpty);
    });
  });
}
