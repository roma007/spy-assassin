import 'package:flutter_test/flutter_test.dart';
import 'package:spy_assassin/features/tracker/tracker_identify.dart';

void main() {
  group('identifyTracker', () {
    test('Apple 0x004C + Find My 负载类型 0x12 → findMy', () {
      final match = identifyTracker({
        0x004C: [0x12, 0x19, 0x10, 0x01, 0x02, 0x03],
      });
      expect(match, isNotNull);
      expect(match!.kind, TrackerKind.findMy);
      expect(match.confidence, 90);
    });

    test('Apple 0x004C 但非 Find My 广播（如 iPhone）→ 不识别', () {
      expect(identifyTracker({0x004C: [0x01, 0x00]}), isNull);
    });

    test('三星 0x0075 → samsungSmartTag', () {
      final match = identifyTracker({0x0075: [0x01, 0x00]});
      expect(match, isNotNull);
      expect(match!.kind, TrackerKind.samsungSmartTag);
    });

    test('Tile 0x02E5 → tile', () {
      final match = identifyTracker({0x02E5: [0x01]});
      expect(match, isNotNull);
      expect(match!.kind, TrackerKind.tile);
    });

    test('Google 0x00E0 → google', () {
      final match = identifyTracker({0x00E0: [0x01]});
      expect(match, isNotNull);
      expect(match!.kind, TrackerKind.google);
    });

    test('空厂商数据 → 不识别', () {
      expect(identifyTracker(const {}), isNull);
    });

    test('未知厂商 ID → 不识别', () {
      expect(identifyTracker({0x1234: [0x12]}), isNull);
    });

    test('多个厂商数据时命中追踪器条目', () {
      final match = identifyTracker({
        0x0006: [0x01], // Microsoft
        0x004C: [0x12, 0x19],
        0x00E0: [0x01],
      });
      expect(match, isNotNull);
      expect(match!.kind, TrackerKind.findMy);
    });
  });
}
