/// 蓝牙设备风险分级（纯函数，便于单测）。
///
/// 规则：
/// - 名称含摄像头/录音相关关键词 → 高风险
/// - 无名称 / 未知设备 → 可疑（中）
/// - 其余 → 低
library;

enum BleRisk { low, medium, high }

/// 名称关键词 → 高风险的匹配规则。
final RegExp _highRiskPattern = RegExp(
  r'(camera|cam\d|spy|spycam|dvr|recorder|rec\b|mic\b|micdroid|摄像头|摄像|摄像机|偷拍|录音|监|mini.?cam)',
  caseSensitive: false,
);

BleRisk assessBluetoothRisk(String? name) {
  final n = name?.trim() ?? '';
  if (n.isEmpty) return BleRisk.medium;
  if (_highRiskPattern.hasMatch(n)) return BleRisk.high;
  return BleRisk.low;
}

String bleRiskLabel(BleRisk risk) => switch (risk) {
      BleRisk.high => '高风险',
      BleRisk.medium => '可疑',
      BleRisk.low => '低风险',
    };
