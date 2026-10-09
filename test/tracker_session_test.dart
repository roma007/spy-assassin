import 'package:flutter_test/flutter_test.dart';
import 'package:spy_assassin/features/tracker/tracker_identify.dart';
import 'package:spy_assassin/features/tracker/tracker_session.dart';

TrackerSighting _sighting(String id, int rssi) =>
    TrackerSighting(deviceId: id, rssi: rssi, kind: TrackerKind.findMy);

void main() {
  group('TrackerSession', () {
    test('同一设备跨多轮出现 → roundsSeen 递增', () {
      final s = TrackerSession();
      s.beginRound();
      s.addSighting(_sighting('a', -50));
      s.beginRound();
      s.addSighting(_sighting('a', -45));

      expect(s.round, 2);
      expect(s.roundsSeen('a'), 2);
      expect(s.allDeviceIds, {'a'});
    });

    test('同一轮内多次出现只计一轮', () {
      final s = TrackerSession();
      s.beginRound();
      s.addSighting(_sighting('a', -50));
      s.addSighting(_sighting('a', -48));

      expect(s.roundsSeen('a'), 1);
    });

    test('latest 返回最近一次观察', () {
      final s = TrackerSession();
      s.beginRound();
      s.addSighting(_sighting('a', -50));
      s.beginRound();
      s.addSighting(_sighting('a', -30));

      expect(s.latest('a')!.rssi, -30);
    });

    test('未出现的设备 latest 为 null', () {
      expect(TrackerSession().latest('x'), isNull);
    });

    test('reset 清空全部轮次与观察', () {
      final s = TrackerSession();
      s.beginRound();
      s.addSighting(_sighting('a', -50));
      s.reset();

      expect(s.round, 0);
      expect(s.allDeviceIds, isEmpty);
      expect(s.latest('a'), isNull);
    });
  });

  group('assessTrackerMotion', () {
    test('≥2 轮出现且信号强 → repeated', () {
      expect(assessTrackerMotion(2, -60), TrackerMotion.repeated);
      expect(assessTrackerMotion(3, -40), TrackerMotion.repeated);
    });

    test('仅 1 轮出现 → once', () {
      expect(assessTrackerMotion(1, -50), TrackerMotion.once);
      expect(assessTrackerMotion(0, -50), TrackerMotion.once);
    });

    test('≥2 轮出现但信号已明显减弱 → once（可能是固定设备）', () {
      expect(assessTrackerMotion(2, -90), TrackerMotion.once);
    });
  });
}
