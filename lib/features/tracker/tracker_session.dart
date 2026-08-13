/// 防跟踪扫描会话：跨多轮扫描累计设备出现情况，判定「是否疑似同行」。
///
/// 判定规则（诚实、保守）：
/// - [TrackerMotion.repeated]：同一设备在 ≥2 轮扫描中都出现
///   （且最新信号强度较强）→「多次扫描仍在你附近」，最值得排查。
/// - [TrackerMotion.once]：仅在其中一轮出现。
/// - [TrackerMotion.regular]：未识别为追踪器的普通设备。
library;

import 'tracker_identify.dart';

/// 设备「移动状态」判定。
enum TrackerMotion { regular, once, repeated }

/// 一次扫描中对某设备的一次观察。
class TrackerSighting {
  const TrackerSighting({
    required this.deviceId,
    required this.rssi,
    required this.kind,
  });

  /// 设备稳定标识（iOS 为 per-device UUID，Android 为 MAC），跨扫描稳定。
  final String deviceId;
  final int rssi;
  final TrackerKind kind;
}

/// 跨轮扫描的会话状态（纯逻辑，不依赖 UI）。
class TrackerSession {
  final Map<String, Set<int>> _deviceRounds = {};
  final Map<String, TrackerSighting> _latest = {};
  int _round = 0;

  /// 当前轮次（第 1 轮从 1 开始）。
  int get round => _round;

  /// 结束当前轮：每次扫描完成时调用一次，随后添加本轮观察。
  void beginRound() => _round++;

  /// 清空会话，用于「重新检查」开始全新一轮完整检测。
  void reset() {
    _deviceRounds.clear();
    _latest.clear();
    _round = 0;
  }

  /// 记录本轮观察到的设备。
  void addSighting(TrackerSighting sighting) {
    _deviceRounds
        .putIfAbsent(sighting.deviceId, () => <int>{})
        .add(_round);
    _latest[sighting.deviceId] = sighting;
  }

  /// 记录到的最新观察（未出现的设备为 null）。
  TrackerSighting? latest(String deviceId) => _latest[deviceId];

  /// 该设备出现在几轮扫描中。
  int roundsSeen(String deviceId) => _deviceRounds[deviceId]?.length ?? 0;

  /// 记录过观察（任一回合）的设备 ID 集合。
  Set<String> get latestDeviceIds => _latest.keys.toSet();

  /// 出现过的全部设备 ID。
  Set<String> get allDeviceIds => _deviceRounds.keys.toSet();
}

/// 依据出现轮次与最新信号强度判定运动状态。
///
/// - ≥2 轮出现且最新 RSSI ≥ -70 → [TrackerMotion.repeated]
/// - ≥2 轮出现但信号已明显减弱 → [TrackerMotion.once]（可能只是附近固定设备）
/// - 仅 1 轮出现 → [TrackerMotion.once]
TrackerMotion assessTrackerMotion(int roundsSeen, int latestRssi) {
  if (roundsSeen <= 1) return TrackerMotion.once;
  return latestRssi >= -70 ? TrackerMotion.repeated : TrackerMotion.once;
}
