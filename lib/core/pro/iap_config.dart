/// 应用内购买产品目录。
///
/// 上线前需在 App Store Connect 与 Google Play Console 创建与本文件同 ID
/// 的产品；无需改 iOS/Android 原生配置，插件直接使用系统 StoreKit /
/// Google Play Billing。
///
/// 全部档位均为自动续期订阅（Auto-Renewable Subscription），
/// 走 `buyNonConsumable`。
enum ProPlan {
  /// 周度自动续期订阅（主力档位）。
  weekly(id: 'com.spyassassin.app.pro.weekly1', days: 7),

  /// 月度自动续期订阅。
  monthly(id: 'com.spyassassin.app.pro.monthly2', days: 30),

  /// 年度自动续期订阅（主推，比周付划算）。
  yearly(id: 'com.spyassassin.app.pro.yearly2', days: 365);

  const ProPlan({required this.id, required this.days});

  /// 商店中的产品 ID。
  final String id;

  /// 订阅周期天数（用于本地信任模型下的到期时间估算）。
  final int days;
}
