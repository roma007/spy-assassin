import 'package:flutter_test/flutter_test.dart';
import 'package:privacy_camera/features/bluetooth/bluetooth_risk.dart';

void main() {
  group('assessBluetoothRisk', () {
    test('名称含摄像头关键词 → 高风险', () {
      expect(assessBluetoothRisk('IP Camera_0001'), BleRisk.high);
      expect(assessBluetoothRisk('spycam'), BleRisk.high);
      expect(assessBluetoothRisk('迷你摄像头'), BleRisk.high);
    });

    test('名称含录音关键词 → 高风险', () {
      expect(assessBluetoothRisk('Voice Recorder'), BleRisk.high);
      expect(assessBluetoothRisk('录音笔'), BleRisk.high);
    });

    test('无名称/空白 → 可疑', () {
      expect(assessBluetoothRisk(null), BleRisk.medium);
      expect(assessBluetoothRisk(''), BleRisk.medium);
      expect(assessBluetoothRisk('   '), BleRisk.medium);
    });

    test('普通设备名 → 低风险', () {
      expect(assessBluetoothRisk('Apple Watch'), BleRisk.low);
      expect(assessBluetoothRisk('Xiaomi Band 7'), BleRisk.low);
      expect(assessBluetoothRisk('AirPods Pro'), BleRisk.low);
    });
  });

  group('bleRiskLabel', () {
    test('风险标签', () {
      expect(bleRiskLabel(BleRisk.high), '高风险');
      expect(bleRiskLabel(BleRisk.medium), '可疑');
      expect(bleRiskLabel(BleRisk.low), '低风险');
    });
  });
}
