import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 本地统计（仅本机保存，不上传）：
/// - Room Check：开始次数、完成次数、累计时长 → 完成率与平均时长
/// - 各检测工具使用次数
class StatStore extends ChangeNotifier {
  StatStore._();

  static final StatStore instance = StatStore._();

  static const _checkStartKey = 'stat_check_started';
  static const _checkDoneKey = 'stat_check_done';
  static const _checkMsKey = 'stat_check_ms';

  static const _irKey = 'stat_tool_ir';
  static const _lensKey = 'stat_tool_lens';
  static const _wifiKey = 'stat_tool_wifi';
  static const _magnetKey = 'stat_tool_magnet';
  static const _bleKey = 'stat_tool_ble';

  int _checkStarted = 0;
  int _checkDone = 0;
  int _checkMs = 0;
  final Map<String, int> _tools = {
    _irKey: 0,
    _lensKey: 0,
    _wifiKey: 0,
    _magnetKey: 0,
    _bleKey: 0,
  };

  int get checkStarted => _checkStarted;
  int get checkDone => _checkDone;
  int get checkTotalMs => _checkMs;

  /// 完成率（0~1；从未开始时为 0）。
  double get completionRate =>
      _checkStarted == 0 ? 0 : _checkDone / _checkStarted;

  /// 平均完成时长（毫秒；无完成记录时 0）。
  int get averageCheckMs =>
      _checkDone == 0 ? 0 : (_checkMs / _checkDone).round();

  int get irCount => _tools[_irKey]!;
  int get lensCount => _tools[_lensKey]!;
  int get wifiCount => _tools[_wifiKey]!;
  int get magnetCount => _tools[_magnetKey]!;
  int get bleCount => _tools[_bleKey]!;

  void recordCheckStarted() {
    _checkStarted++;
    notifyListeners();
    _persist();
  }

  void recordCheckCompleted(int elapsedMs) {
    _checkDone++;
    _checkMs += elapsedMs;
    notifyListeners();
    _persist();
  }

  void recordTool(String key) {
    final current = _tools[key];
    if (current == null) return;
    _tools[key] = current + 1;
    notifyListeners();
    _persist();
  }

  void recordIr() => recordTool(_irKey);
  void recordLens() => recordTool(_lensKey);
  void recordWifi() => recordTool(_wifiKey);
  void recordMagnet() => recordTool(_magnetKey);
  void recordBle() => recordTool(_bleKey);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _checkStarted = prefs.getInt(_checkStartKey) ?? 0;
    _checkDone = prefs.getInt(_checkDoneKey) ?? 0;
    _checkMs = prefs.getInt(_checkMsKey) ?? 0;
    for (final key in _tools.keys) {
      _tools[key] = prefs.getInt(key) ?? 0;
    }
    notifyListeners();
  }

  /// 清除全部本地统计。
  Future<void> clear() async {
    _checkStarted = 0;
    _checkDone = 0;
    _checkMs = 0;
    for (final key in _tools.keys) {
      _tools[key] = 0;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_checkStartKey);
    await prefs.remove(_checkDoneKey);
    await prefs.remove(_checkMsKey);
    for (final key in _tools.keys) {
      await prefs.remove(key);
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_checkStartKey, _checkStarted);
    await prefs.setInt(_checkDoneKey, _checkDone);
    await prefs.setInt(_checkMsKey, _checkMs);
    for (final entry in _tools.entries) {
      await prefs.setInt(entry.key, entry.value);
    }
  }
}
