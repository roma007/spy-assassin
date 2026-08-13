/// 追踪器识别（纯函数，便于单测）。
///
/// 通过 BLE 广播包中的厂商数据（manufacturer data）识别已知品牌的追踪器：
/// - AirTag / Find My 配件：Apple 厂商 ID 0x004C + 负载类型字节 0x12
///   （Find My 网络广播）。该规则覆盖 AirTag 及 Chipolo ONE Spot 等兼容配件。
/// - 三星 SmartTag：厂商 ID 0x0075
/// - Tile：厂商 ID 0x02E5
/// - Google 追踪器：厂商 ID 0x00E0
///
/// 厂商 ID 以 Bluetooth SIG 官方分配表为准。所有命中仅表示「候选」，
/// 不代表确认为追踪器（诚实定位，也降低审核风险）。
library;

/// 识别出的追踪器类型。
enum TrackerKind { findMy, samsungSmartTag, tile, google }

/// 识别结果：类型 + 命中可信度（0~100）。
class TrackerMatch {
  const TrackerMatch(this.kind, this.confidence);

  final TrackerKind kind;

  /// 命中可信度：仅凭厂商 ID 命中给较低分，带 Find My 特征给较高分。
  final int confidence;
}

/// Find My 网络广播的负载类型字节（manufacturer data 首个字节）。
const int _findMyPayloadType = 0x12;

/// 已知厂商 ID（Bluetooth SIG Company Identifiers，十进制）。
const int _appleCompanyId = 0x004C;
const int _samsungCompanyId = 0x0075;
const int _tileCompanyId = 0x02E5;
const int _googleCompanyId = 0x00E0;

/// 从厂商数据中识别已知追踪器；未命中返回 null。
///
/// [manufacturerData] 为 `flutter_blue_plus` 的 `advertisementData.manufacturerData`，
/// key 是厂商 ID（int），value 是厂商数据字节（不含厂商 ID 本身）。
TrackerMatch? identifyTracker(Map<int, List<int>> manufacturerData) {
  for (final entry in manufacturerData.entries) {
    final match = _matchCompany(entry.key, entry.value);
    if (match != null) return match;
  }
  return null;
}

TrackerMatch? _matchCompany(int companyId, List<int> data) {
  switch (companyId) {
    case _appleCompanyId:
      // Apple 厂商 ID 也被 iPhone 等设备使用，必须同时命中 Find My 负载类型。
      if (data.isNotEmpty && data[0] == _findMyPayloadType) {
        return const TrackerMatch(TrackerKind.findMy, 90);
      }
      return null;
    case _samsungCompanyId:
      return const TrackerMatch(TrackerKind.samsungSmartTag, 70);
    case _tileCompanyId:
      return const TrackerMatch(TrackerKind.tile, 70);
    case _googleCompanyId:
      return const TrackerMatch(TrackerKind.google, 70);
    default:
      return null;
  }
}
