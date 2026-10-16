import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'iap_config.dart';

/// Pro 权益与免费扫描配额管理。
///
/// 商业化模型（Peek 模式，收入最大化）：
/// - 免费用户可完成 1 次完整扫描（含全部检测模式），以感知产品价值；
/// - 第 2 次及以后扫描、PDF 报告导出、详细报告明细、无限历史存档，
///   均需 Pro 订阅/买断解锁。
///
/// 本类不再提供本地模拟解锁入口（`unlock()` 已移除），所有权益
/// 仅来自真实 IAP 交易（[activateIap]），符合上架销售标准。
class ProStore extends ChangeNotifier {
  ProStore._();

  static final ProStore instance = ProStore._();

  static const _iapActiveKey = 'iap_active';
  static const _iapPlanKey = 'iap_plan_id';
  static const _iapExpiryKey = 'iap_expiry_ms';
  static const _freeScansUsedKey = 'free_scans_used';

  /// 免费扫描计数走 Keychain（iOS 删除重装 App 后仍保留），防止重装刷次数。
  static const _secure = FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  /// 读 Keychain 计数；测试环境无插件实现时静默回退 null。
  static Future<String?> _secureRead(String key) async {
    try {
      return await _secure.read(key: key);
    } catch (_) {
      return null;
    }
  }

  /// 写 Keychain 计数；测试环境无插件实现时静默忽略。
  static Future<void> _secureWrite(String key, String value) async {
    try {
      await _secure.write(key: key, value: value);
    } catch (_) {}
  }

  /// 免费用户可使用的完整扫描次数。
  static const int freeScanQuota = 1;

  bool _iapActive = false;
  String _iapPlanId = '';
  DateTime? _iapExpiry;
  int _freeScansUsed = 0;

  /// 是否为 Pro（真实订阅在效期内）。
  bool get isPro => _iapActive;

  /// 是否持有真实订阅。
  bool get isIapActive => _iapActive;

  /// 当前真实订阅套餐。
  ProPlan? get iapPlan =>
      ProPlan.values.where((p) => p.id == _iapPlanId).firstOrNull;

  /// 当前真实订阅到期时间（本地估算）。
  DateTime? get iapExpiry => _iapExpiry;

  /// 剩余免费扫描次数（仅对非 Pro 用户有意义）。
  int get freeScansRemaining =>
      isPro ? 0 : (freeScanQuota - _freeScansUsed).clamp(0, freeScanQuota);

  /// 是否已用完免费扫描次数。
  bool get freeScansExhausted => !isPro && freeScansRemaining <= 0;

  /// 真实购买/恢复成功后激活权益。
  void activateIap({required ProPlan plan, DateTime? expiry}) {
    _iapActive = true;
    _iapPlanId = plan.id;
    _iapExpiry = expiry ?? DateTime.now().add(Duration(days: plan.days));
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

  /// 消耗 1 次免费扫描。返回 true 表示消耗成功（仍有额度），
  /// false 表示已用尽，调用方应弹付费墙。Pro 用户直接返回 true。
  bool consumeFreeScan() {
    if (isPro) return true;
    if (_freeScansUsed >= freeScanQuota) return false;
    _freeScansUsed++;
    notifyListeners();
    _persist();
    return true;
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _iapActive = prefs.getBool(_iapActiveKey) ?? false;
    _iapPlanId = prefs.getString(_iapPlanKey) ?? '';
    final expiryMs = prefs.getInt(_iapExpiryKey);
    _iapExpiry = expiryMs == null ? null : DateTime.fromMillisecondsSinceEpoch(expiryMs);
    // 免费次数优先读 Keychain；老版本数据在 SharedPreferences，做一次迁移。
    final secureVal = await _secureRead(_freeScansUsedKey);
    if (secureVal != null) {
      _freeScansUsed = int.tryParse(secureVal) ?? 0;
    } else {
      _freeScansUsed = prefs.getInt(_freeScansUsedKey) ?? 0;
      if (_freeScansUsed > 0) {
        await _secureWrite(_freeScansUsedKey, '$_freeScansUsed');
        await prefs.remove(_freeScansUsedKey);
      }
    }
    if (_iapActive && _iapExpiry != null && _iapExpiry!.isBefore(DateTime.now())) {
      _iapActive = false;
      _iapPlanId = '';
      _iapExpiry = null;
    }
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_iapActiveKey, _iapActive);
    await prefs.setString(_iapPlanKey, _iapPlanId);
    final expiryMs = _iapExpiry?.millisecondsSinceEpoch;
    if (expiryMs != null) {
      await prefs.setInt(_iapExpiryKey, expiryMs);
    } else {
      await prefs.remove(_iapExpiryKey);
    }
    await _secureWrite(_freeScansUsedKey, '$_freeScansUsed');
  }
}
