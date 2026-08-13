import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'iap_config.dart';

/// Pro 订阅状态。
///
/// 两种来源：
/// - 真实 IAP（[activateIap]，由 [IapStore] 在交易成功后调用）；
/// - 本地模拟解锁（[unlock]，仅供调试/预上线环境使用）。
///
/// 商业化模型：全部检测工具免费无限次使用，Pro 解锁「无限历史存档」
/// 与后续 AI 高级功能（见 [ProStore.isPro] 的消费点）。
class ProStore extends ChangeNotifier {
  ProStore._();

  static final ProStore instance = ProStore._();

  static const _proKey = 'pro_enabled';
  static const _iapActiveKey = 'iap_active';
  static const _iapPlanKey = 'iap_plan_id';
  static const _iapExpiryKey = 'iap_expiry_ms';

  bool _localSim = false;
  bool _iapActive = false;
  String _iapPlanId = '';
  DateTime? _iapExpiry;

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
    if (_iapActive && _iapExpiry != null && _iapExpiry!.isBefore(DateTime.now())) {
      _iapActive = false;
      _iapPlanId = '';
      _iapExpiry = null;
    }
    notifyListeners();
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
  }
}
