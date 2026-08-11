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

    test('常见摄像头 Web 端口 → 可疑', () {
      const d = LanDevice(ip: '192.168.1.11', openPorts: [80, 8080]);
      expect(d.isMediumRisk, isTrue);
      expect(d.riskLabel, '可疑');
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

    test('普通厂商 + Web 端口 → 可疑（非高风险）', () {
      const d = LanDevice(
        ip: '192.168.1.14',
        openPorts: [80],
        vendor: 'Apple',
      );
      expect(d.isMediumRisk, isTrue);
      expect(d.isHighRisk, isFalse);
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
