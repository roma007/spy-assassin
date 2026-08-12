import 'package:flutter/material.dart';
import 'package:privacy_camera/l10n/app_localizations.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_widgets.dart';
import '../check/next_actions_screen.dart';

/// 排查指南：高危点图文清单 + 发现异常后的下一步行动。
class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const GuideScreen());

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final points = _points(l10n);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.guideTitle)),
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        children: [
          SectionCard(
            child: Text(
              l10n.guideIntro,
              style: const TextStyle(
                  fontSize: 12.5, color: AppColors.textSecondary, height: 1.5),
            ),
          ),
          for (var i = 0; i < points.length; i++)
            _PointCard(point: points[i], index: i + 1),
          SectionCard(
            child: FilledButton.icon(
              onPressed: () =>
                  Navigator.of(context).push(NextActionsScreen.route()),
              icon: const Icon(Icons.health_and_safety_rounded),
              label: Text(l10n.guideCta),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuidePoint {
  const _GuidePoint({
    required this.icon,
    required this.title,
    required this.check,
    required this.hint,
  });

  final IconData icon;
  final String title;
  final String check;
  final String hint;
}

List<_GuidePoint> _points(AppLocalizations l10n) => [
      _GuidePoint(
        icon: Icons.smoke_free_rounded,
        title: l10n.guideP1Title,
        check: l10n.guideP1Check,
        hint: l10n.guideP1Hint,
      ),
      _GuidePoint(
        icon: Icons.power_rounded,
        title: l10n.guideP2Title,
        check: l10n.guideP2Check,
        hint: l10n.guideP2Hint,
      ),
      _GuidePoint(
        icon: Icons.face_retouching_natural_rounded,
        title: l10n.guideP3Title,
        check: l10n.guideP3Check,
        hint: l10n.guideP3Hint,
      ),
      _GuidePoint(
        icon: Icons.image_rounded,
        title: l10n.guideP4Title,
        check: l10n.guideP4Check,
        hint: l10n.guideP4Hint,
      ),
      _GuidePoint(
        icon: Icons.air_rounded,
        title: l10n.guideP5Title,
        check: l10n.guideP5Check,
        hint: l10n.guideP5Hint,
      ),
      _GuidePoint(
        icon: Icons.alarm_rounded,
        title: l10n.guideP6Title,
        check: l10n.guideP6Check,
        hint: l10n.guideP6Hint,
      ),
      _GuidePoint(
        icon: Icons.router_rounded,
        title: l10n.guideP7Title,
        check: l10n.guideP7Check,
        hint: l10n.guideP7Hint,
      ),
      _GuidePoint(
        icon: Icons.local_florist_rounded,
        title: l10n.guideP8Title,
        check: l10n.guideP8Check,
        hint: l10n.guideP8Hint,
      ),
      _GuidePoint(
        icon: Icons.light_rounded,
        title: l10n.guideP9Title,
        check: l10n.guideP9Check,
        hint: l10n.guideP9Hint,
      ),
    ];

class _PointCard extends StatelessWidget {
  const _PointCard({required this.point, required this.index});

  final _GuidePoint point;
  final int index;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SectionCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(point.icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$index. ${point.title}',
                    style: const TextStyle(
                        fontSize: 14.5, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text('${l10n.guideHow}${point.check}',
                    style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textPrimary,
                        height: 1.5)),
                const SizedBox(height: 4),
                Text('${l10n.guideHint}${point.hint}',
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
