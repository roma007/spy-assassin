import 'package:privacy_camera/l10n/app_localizations.dart';

import '../report/report_store.dart';

/// 供非 Widget 上下文（PDF 等）使用的本地化辅助方法。
extension AppL10n on AppLocalizations {
  /// 功能标识 → 本地化显示名。
  String featureTitle(String featureKey) => switch (featureKey) {
        'ir' => featureIr,
        'lens' => featureLens,
        'wifi' => featureWifi,
        'bluetooth' => featureBluetooth,
        'magnet' => featureMagnet,
        _ => featureKey,
      };

  /// 风险等级 → 本地化标签。
  String riskLabel(ReportRisk risk) => switch (risk) {
        ReportRisk.safe => riskSafe,
        ReportRisk.low => riskLow,
        ReportRisk.high => riskHigh,
      };
}
