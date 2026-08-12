import 'package:flutter/foundation.dart';

/// 一次检测的结论分级。
enum ReportRisk { safe, low, high }

/// 单条检测记录（持久化后可恢复）。
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

  Map<String, dynamic> toJson() => {
        'featureKey': featureKey,
        'time': time.toIso8601String(),
        'risk': risk.index,
        'summary': summary,
        'wifiName': wifiName,
      };

  factory ReportEntry.fromJson(Map<String, dynamic> json) {
    final riskIndex = json['risk'] as int? ?? 0;
    final risk = riskIndex >= 0 && riskIndex < ReportRisk.values.length
        ? ReportRisk.values[riskIndex]
        : ReportRisk.safe;
    return ReportEntry(
      featureKey: json['featureKey'] as String,
      time: DateTime.tryParse(json['time'] as String? ?? '') ?? DateTime.now(),
      risk: risk,
      summary: json['summary'] as String? ?? '',
      wifiName: json['wifiName'] as String?,
    );
  }
}

/// 会话内检测结果汇总（内存单例，可持久化到本地）。所有数据仅在本机存在。
class ReportStore extends ChangeNotifier {
  ReportStore._();

  static final ReportStore instance = ReportStore._();

  final List<ReportEntry> _entries = [];
  final List<Uint8List> _photos = [];
  String _place = '';

  List<ReportEntry> get entries => List.unmodifiable(_entries);

  /// 现场照片（导出 PDF 时读取）。
  List<Uint8List> get photos => List.unmodifiable(_photos);

  /// 检查地点（可选，酒店名/房号），随报告一起持久化。
  String get place => _place;

  set place(String value) {
    if (_place == value) return;
    _place = value;
    notifyListeners();
  }

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

  /// 用历史记录替换当前会话内容（仅内存，由归档层负责落盘）。
  void replaceAll(List<ReportEntry> entries, List<Uint8List> photos,
      {String place = ''}) {
    _entries
      ..clear()
      ..addAll(entries);
    _photos
      ..clear()
      ..addAll(photos);
    _place = place;
    notifyListeners();
  }

  void clear() {
    _entries.clear();
    _photos.clear();
    _place = '';
    notifyListeners();
  }
}
