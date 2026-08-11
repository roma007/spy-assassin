import 'package:flutter/foundation.dart';

/// 一次检测的结论分级。
enum ReportRisk { safe, low, high }

/// 单条检测记录（仅内存，不落盘）。
class ReportEntry {
  const ReportEntry({
    required this.featureKey,
    required this.time,
    required this.risk,
    required this.summary,
    this.wifiName,
  });

  /// 'ir' / 'lens' / 'wifi' / 'bluetooth' / 'magnet'。
  final String featureKey;
  final DateTime time;
  final ReportRisk risk;

  /// 人类可读的结论说明（含设备明细）。
  final String summary;

  /// WiFi 检测对应的网络名（仅 [featureKey] == 'wifi' 时存在）。
  final String? wifiName;
}

/// 会话内检测结果汇总（内存单例）。所有数据仅在本机存在，退出即消失。
class ReportStore extends ChangeNotifier {
  ReportStore._();

  static final ReportStore instance = ReportStore._();

  final List<ReportEntry> _entries = [];
  final List<Uint8List> _photos = [];

  List<ReportEntry> get entries => List.unmodifiable(_entries);

  /// 现场照片（仅内存，导出 PDF 时读取）。
  List<Uint8List> get photos => List.unmodifiable(_photos);

  int get riskCount =>
      _entries.where((e) => e.risk != ReportRisk.safe).length;

  void add(ReportEntry entry) {
    _entries.add(entry);
    notifyListeners();
  }

  void addPhoto(Uint8List bytes) {
    _photos.add(bytes);
    notifyListeners();
  }

  void removePhoto(int index) {
    if (index >= 0 && index < _photos.length) {
      _photos.removeAt(index);
      notifyListeners();
    }
  }

  void clear() {
    _entries.clear();
    _photos.clear();
    notifyListeners();
  }
}
