import 'package:flutter_test/flutter_test.dart';
import 'package:privacy_camera/features/wifi/lan_scanner.dart';

void main() {
  group('LanDevice 风险分级', () {
    test('命中摄像头特征端口 → 高风险', () {
      const d = LanDevice(ip: '192.168.1.10', openPorts: [554]);
      expect(d.isHighRisk, isTrue);
      expect(d.riskLabel, '高风险');
    });

    test('雄迈/大华协议端口 → 高风险', () {
      expect(
        const LanDevice(ip: '1.1.1.1', openPorts: [34567]).isHighRisk,
        isTrue,
      );
      expect(
        const LanDevice(ip: '1.1.1.1', openPorts: [37777]).isHighRisk,
        isTrue,
      );
      expect(
        const LanDevice(ip: '1.1.1.1', openPorts: [9000]).isHighRisk,
        isTrue,
      );
    });

    test('仅通用 Web 端口（80/8080）→ 低风险', () {
      const d = LanDevice(ip: '192.168.1.11', openPorts: [80, 8080]);
      expect(d.isMediumRisk, isFalse);
      expect(d.isHighRisk, isFalse);
      expect(d.riskLabel, '低风险');
    });

    test('摄像头专属 Web 端口（8000）→ 可疑', () {
      const d = LanDevice(ip: '192.168.1.15', openPorts: [8000]);
      expect(d.isMediumRisk, isTrue);
      expect(d.riskLabel, '可疑');
    });

    test('RTSP 指纹确认 → 高风险', () {
      const d = LanDevice(
        ip: '192.168.1.16',
        openPorts: [80],
        rtspServer: 'Tapo RTSP Server',
      );
      expect(d.isHighRisk, isTrue);
    });

    test('HTTP 指纹疑似摄像头 → 可疑', () {
      const d = LanDevice(
        ip: '192.168.1.17',
        openPorts: [80],
        httpTitle: 'IPCAM Web Login',
      );
      expect(d.isMediumRisk, isTrue);
    });

    test('HTTP 指纹为路由器/服务器 → 低风险（不误报）', () {
      const nginx = LanDevice(ip: '192.168.1.18', openPorts: [80, 8080],
          httpServer: 'nginx');
      expect(nginx.isMediumRisk, isFalse);
      const router = LanDevice(ip: '192.168.1.19', openPorts: [80],
          httpTitle: 'MiWiFi 路由器');
      expect(router.isMediumRisk, isFalse);
    });

    test('摄像头厂商 + 开放端口 → 高风险', () {
      const d = LanDevice(
        ip: '192.168.1.12',
        openPorts: [8080],
        vendor: '海康威视',
      );
      expect(d.isHighRisk, isTrue);
    });

    test('摄像头厂商但无端口 → 可疑', () {
      const d = LanDevice(
        ip: '192.168.1.13',
        openPorts: [],
        vendor: '大华',
      );
      expect(d.isMediumRisk, isTrue);
    });

    test('普通厂商 + Web 端口 → 低风险', () {
      const d = LanDevice(
        ip: '192.168.1.14',
        openPorts: [80],
        vendor: 'Apple',
      );
      expect(d.isMediumRisk, isFalse);
      expect(d.isHighRisk, isFalse);
    });

    test('reason 包含指纹行', () {
      const d = LanDevice(
        ip: '192.168.1.20',
        openPorts: [554, 80],
        rtspServer: 'Tapo RTSP Server',
        httpTitle: 'Tapo Camera',
      );
      expect(d.reason, contains('RTSP 指纹：Tapo RTSP Server'));
      expect(d.reason, contains('HTTP 指纹：Tapo Camera'));
    });

    test('stale 不影响风险计算', () {
      const d = LanDevice(
        ip: '192.168.1.21',
        openPorts: [554],
        stale: true,
      );
      expect(d.isHighRisk, isTrue);
      expect(d.reason, contains('本次未响应（可能休眠）'));
    });
  });

  group('FingerprintDb', () {
    test('摄像头关键词命中', () {
      expect(FingerprintDb.looksLikeCamera('Tapo C200'), isTrue);
      expect(FingerprintDb.looksLikeCamera('Hikvision-IPC'), isTrue);
      expect(FingerprintDb.looksLikeCamera('RTSP/1.0 200 OK'), isTrue);
      expect(FingerprintDb.looksLikeCamera('IPC'), isTrue);
    });

    test('普通设备不命中', () {
      expect(FingerprintDb.looksLikeCamera('nginx'), isFalse);
      expect(FingerprintDb.looksLikeCamera('MiWiFi Router'), isFalse);
      expect(FingerprintDb.looksLikeCamera(null), isFalse);
      expect(FingerprintDb.looksLikeCamera(''), isFalse);
    });
  });

  group('OuiDb / ouiLookupVendor', () {
    test('冒号格式匹配海康', () {
      expect(ouiLookupVendor('44:19:B6:12:34:56'), '海康威视');
    });

    test('短横线格式归一化', () {
      expect(ouiLookupVendor('44-19-B6-12-34-56'), '海康威视');
    });

    test('小写输入归一化', () {
      expect(ouiLookupVendor('78:11:dc:aa:bb:cc'), '小米');
    });

    test('未知 OUI 返回 null', () {
      expect(ouiLookupVendor('FF:FF:FF:00:00:00'), isNull);
    });

    test('非法 MAC 返回 null', () {
      expect(ouiLookupVendor('abcd'), isNull);
    });
  });

  group('ArpTable（iOS 无 /proc）', () {
    test('无文件时返回空表', () async {
      final map = await ArpTable.read();
      expect(map, isEmpty);
    });
  });

  group('deriveSubnet', () {
    test('私有 IP 推导网段', () {
      expect(deriveSubnet('192.168.31.22'), '192.168.31');
      expect(deriveSubnet('10.0.0.5'), '10.0.0');
      expect(deriveSubnet('invalid'), isNull);
    });
  });
}
