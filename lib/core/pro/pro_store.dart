import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 本地模拟的 Pro 订阅状态（上架前替换为 in_app_purchase 真实结算）。
/// 免费用户每日可检测 [maxFreePerDay] 次；Pro 无限次并解锁报告导出。
class ProStore extends ChangeNotifier {
  ProStore._();

  static final ProStore instance = ProStore._();

  static const _proKey = 'pro_enabled';
  static const _dateKey = 'pro_use_date';
  static const _countKey = 'pro_use_count';

  static const int maxFreePerDay = 5;

  bool _isPro = false;
  String _date = '';
  int _count = 0;

  bool get isPro => _isPro;

  /// 今日剩余免费次数（Pro 为无限，返回 [int].max）。
  int get remainingToday {
    if (_isPro) return 0x7fffffff;
    _ensureDate();
    final left = maxFreePerDay - _count;
    return left > 0 ? left : 0;
  }

  /// 允许本次使用：Pro 或仍有免费次数时消耗一次并返回 true。
  bool consumeUse() {
    if (_isPro) return true;
    _ensureDate();
    if (_count >= maxFreePerDay) return false;
    _count++;
    notifyListeners();
    _persist();
    return true;
  }

  /// 本地模拟解锁（后续接真实 IAP 购买流程）。
  void unlock() {
    _isPro = true;
    notifyListeners();
    _persist();
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isPro = prefs.getBool(_proKey) ?? false;
    _date = prefs.getString(_dateKey) ?? '';
    _count = prefs.getInt(_countKey) ?? 0;
    _ensureDate();
    notifyListeners();
  }

  void _ensureDate() {
    final today = DateTime.now().toString().substring(0, 10);
    if (_date != today) {
      _date = today;
      _count = 0;
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_proKey, _isPro);
    await prefs.setString(_dateKey, _date);
    await prefs.setInt(_countKey, _count);
  }
}
