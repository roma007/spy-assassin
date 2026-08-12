import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'iap_config.dart';

/// Pro 订阅状态。
///
/// 两种来源：
/// - 真实 IAP（[activateIap]，由 [IapStore] 在交易成功后调用）；
/// - 本地模拟解锁（[unlock]，仅供调试/预上线环境使用）。
/// 免费用户每日可检测 [maxFreePerDay] 次；Pro 无限次并解锁报告导出。
class ProStore extends ChangeNotifier {
  ProStore._();

  static final ProStore instance = ProStore._();

  static const _proKey = 'pro_enabled';
  static const _iapActiveKey = 'iap_active';
  static const _iapPlanKey = 'iap_plan_id';
  static const _iapExpiryKey = 'iap_expiry_ms';
  static const _dateKey = 'pro_use_date';
  static const _countKey = 'pro_use_count';

  static const int maxFreePerDay = 5;

  bool _localSim = false;
  bool _iapActive = false;
  String _iapPlanId = '';
  DateTime? _iapExpiry;
  String _date = '';
  int _count = 0;

  /// 是否为 Pro（本地模拟或真实 IAP 任一成立）。
  bool get isPro => _localSim || _iapActive;

  /// 是否为本地模拟解锁（仅调试可见）。
  bool get isLocalSim => _localSim;

  /// 是否持有真实订阅。
  bool get isIapActive => _iapActive;

  /// 当前真实订阅套餐。
  ProPlan? get iapPlan =>
      ProPlan.values.where((p) => p.id == _iapPlanId).firstOrNull;

  /// 当前真实订阅到期时间（本地估算）。
  DateTime? get iapExpiry => _iapExpiry;

  /// 今日剩余免费次数（Pro 为无限，返回 [int].max）。
  int get remainingToday {
    if (isPro) return 0x7fffffff;
    _ensureDate();
    final left = maxFreePerDay - _count;
    return left > 0 ? left : 0;
  }

  /// 允许本次使用：Pro 或仍有免费次数时消耗一次并返回 true。
  bool consumeUse() {
    if (isPro) return true;
    _ensureDate();
    if (_count >= maxFreePerDay) return false;
    _count++;
    notifyListeners();
    _persist();
    return true;
  }

  /// 本地模拟解锁（调试/预上线，无真实扣费）。
  void unlock() {
    _localSim = true;
    notifyListeners();
    _persist();
  }

  /// 真实购买/恢复成功后激活权益。
  void activateIap({required ProPlan plan, DateTime? expiry}) {
    _iapActive = true;
    _iapPlanId = plan.id;
    _iapExpiry = expiry ?? DateTime.now().add(Duration(days: plan.days));
    _localSim = false;
    notifyListeners();
    _persist();
  }

  /// 订阅到期降级（真实订阅以 StoreKit 收据为准，本地仅作展示）。
  void deactivateIap() {
    _iapActive = false;
    _iapPlanId = '';
    _iapExpiry = null;
    notifyListeners();
    _persist();
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _localSim = prefs.getBool(_proKey) ?? false;
    _iapActive = prefs.getBool(_iapActiveKey) ?? false;
    _iapPlanId = prefs.getString(_iapPlanKey) ?? '';
    final expiryMs = prefs.getInt(_iapExpiryKey);
    _iapExpiry = expiryMs == null ? null : DateTime.fromMillisecondsSinceEpoch(expiryMs);
    _date = prefs.getString(_dateKey) ?? '';
    _count = prefs.getInt(_countKey) ?? 0;
    _ensureDate();
    if (_iapActive && _iapExpiry != null && _iapExpiry!.isBefore(DateTime.now())) {
      _iapActive = false;
      _iapPlanId = '';
      _iapExpiry = null;
    }
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
    await prefs.setBool(_proKey, _localSim);
    await prefs.setBool(_iapActiveKey, _iapActive);
    await prefs.setString(_iapPlanKey, _iapPlanId);
    final expiryMs = _iapExpiry?.millisecondsSinceEpoch;
    if (expiryMs != null) {
      await prefs.setInt(_iapExpiryKey, expiryMs);
    } else {
      await prefs.remove(_iapExpiryKey);
    }
    await prefs.setString(_dateKey, _date);
    await prefs.setInt(_countKey, _count);
  }
}
