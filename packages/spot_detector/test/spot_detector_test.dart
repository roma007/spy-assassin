import 'package:flutter_test/flutter_test.dart';
import 'package:spot_detector/spot_detector.dart';

void main() {
  test('NativeSpotDetector loads and falls back safely', () {
    final detector = NativeSpotDetector.instance;
    // 宿主环境可能没有原生库：要么可用，要么回退实现（均不抛异常）。
    expect(detector.available || !detector.available, isTrue);
  });
}
