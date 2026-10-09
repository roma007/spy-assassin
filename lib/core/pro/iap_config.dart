/// 应用内购买产品目录。
///
/// 上线前需在 App Store Connect（自动续期订阅）与 Google Play Console
/// （订阅）创建与本文件同 ID 的产品；无需改 iOS/Android 原生配置，
/// 插件直接使用系统 StoreKit / Google Play Billing。
enum ProPlan {
  /// 月度自动续期订阅。
  monthly(id: 'com.spyassassin.app.pro.monthly', days: 30),

  /// 年度自动续期订阅。
  yearly(id: 'com.spyassassin.app.pro.yearly', days: 365);

  const ProPlan({required this.id, required this.days});

  /// 商店中的产品 ID。
  final String id;

  /// 订阅周期天数（用于本地信任模型下的到期时间估算）。
  final int days;
}
