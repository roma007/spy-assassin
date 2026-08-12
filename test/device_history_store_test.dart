import 'package:flutter_test/flutter_test.dart';
import 'package:privacy_camera/features/wifi/device_history_store.dart';
import 'package:privacy_camera/features/wifi/lan_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('DeviceHistoryRecord JSON', () {
    test('roundtrip 保留字段', () {
      final rec = DeviceHistoryRecord(
        ip: '192.168.31.132',
        mac: 'A4:1A:3A:53:4F:7F',
        vendor: 'TP-Link',
        openPorts: const [554, 80],
        rtspServer: 'Tapo RTSP Server',
        httpTitle: 'IPC',
        firstSeenAt: DateTime(2026, 8, 1, 10, 0),
        lastSeenAt: DateTime(2026, 8, 12, 9, 30),
        everCamera: true,
      );
      final json = rec.toJson();
      final back = DeviceHistoryRecord.fromJson(rec.ip, json);
      expect(back.ip, rec.ip);
      expect(back.mac, rec.mac);
      expect(back.vendor, rec.vendor);
      expect(back.openPorts, rec.openPorts);
      expect(back.rtspServer, rec.rtspServer);
      expect(back.httpTitle, rec.httpTitle);
      expect(back.firstSeenAt, rec.firstSeenAt);
      expect(back.lastSeenAt, rec.lastSeenAt);
      expect(back.everCamera, isTrue);
    });

    test('空字段反序列化安全', () {
      final back = DeviceHistoryRecord.fromJson('1.2.3.4', const {});
      expect(back.openPorts, isEmpty);
      expect(back.mac, isNull);
      expect(back.everCamera, isFalse);
    });
  });

  group('staleFromHistory', () {
    test('仅回填曾经确认是摄像头且本次未响应的设备', () {
      final history = {
        '192.168.31.132': const DeviceHistoryRecord(
          ip: '192.168.31.132',
          openPorts: [554, 80],
          everCamera: true,
          lastSeenAt: null,
        ),
        '192.168.31.10': const DeviceHistoryRecord(
          ip: '192.168.31.10',
          openPorts: [443, 8080],
          everCamera: false,
        ),
      };
      final stale =
          DeviceHistoryStore.staleFromHistory(history, const {'192.168.31.10'});
      expect(stale, hasLength(1));
      expect(stale.single.ip, '192.168.31.132');
      expect(stale.single.stale, isTrue);
      expect(stale.single.openPorts, [554, 80]);
    });

    test('本次在线的设备不回填为休眠', () {
      final history = {
        '192.168.31.132': const DeviceHistoryRecord(
          ip: '192.168.31.132',
          openPorts: [554],
          everCamera: true,
        ),
      };
      final stale =
          DeviceHistoryStore.staleFromHistory(history, const {'192.168.31.132'});
      expect(stale, isEmpty);
    });
  });

  group('save / load', () {
    test('在线设备写入历史并保留 lastSeen/everCamera', () async {
      SharedPreferences.setMockInitialValues({});
      final live = [
        const LanDevice(ip: '192.168.31.132', openPorts: [554, 80]),
        const LanDevice(ip: '192.168.31.10', openPorts: [443, 8080]),
      ];
      await DeviceHistoryStore.save(live);
      final history = await DeviceHistoryStore.load();
      final cam = history['192.168.31.132']!;
      expect(cam.everCamera, isTrue);
      expect(cam.openPorts, [554, 80]);
      expect(cam.lastSeenAt, isNotNull);
      // 仅开放通用 Web 端口 → 非摄像头，不记 everCamera
      expect(history['192.168.31.10']!.everCamera, isFalse);
    });

    test('save 跳过 stale 设备', () async {
      SharedPreferences.setMockInitialValues({});
      await DeviceHistoryStore.save(const [
        LanDevice(ip: '192.168.31.132', openPorts: [554], stale: true),
      ]);
      final history = await DeviceHistoryStore.load();
      expect(history, isEmpty);
    });
  });
}
