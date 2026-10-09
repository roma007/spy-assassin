import 'package:flutter/material.dart';
import 'package:spy_assassin/l10n/app_localizations.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_widgets.dart';

/// 发现疑似隐藏摄像头后的下一步行动指引：取证 → 联系场所 → 报警。
class NextActionsScreen extends StatelessWidget {
  const NextActionsScreen({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const NextActionsScreen());

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final steps = [
      _ActionStep(
        icon: Icons.photo_camera_rounded,
        title: l10n.nextAction1Title,
        desc: l10n.nextAction1Desc,
      ),
      _ActionStep(
        icon: Icons.support_agent_rounded,
        title: l10n.nextAction2Title,
        desc: l10n.nextAction2Desc,
      ),
      _ActionStep(
        icon: Icons.local_police_rounded,
        title: l10n.nextAction3Title,
        desc: l10n.nextAction3Desc,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.nextActionsTitle)),
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        children: [
          SectionCard(
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded,
                    color: AppColors.riskHigh, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.nextActionsTip,
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textSecondary, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
          for (final s in steps)
            SectionCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(s.icon, color: AppColors.primary, size: 26),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.title,
                            style: const TextStyle(
                                fontSize: 14.5, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        Text(s.desc,
                            style: const TextStyle(
                                fontSize: 12.5,
                                color: AppColors.textSecondary,
                                height: 1.6)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          SectionCard(
            child: Text(
              l10n.nextActionsRightsTip,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionStep {
  const _ActionStep({
    required this.icon,
    required this.title,
    required this.desc,
  });

  final IconData icon;
  final String title;
  final String desc;
}
