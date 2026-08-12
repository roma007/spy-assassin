import 'package:flutter/material.dart';
import 'package:privacy_camera/l10n/app_localizations.dart';

import '../../core/pro/iap_config.dart';
import '../../core/pro/pro_store.dart';
import '../../core/pro/upgrade_dialog.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_widgets.dart';
import '../bluetooth/bluetooth_screen.dart';
import '../lens/lens_screen.dart';
import '../report/history_screen.dart';
import '../report/report_screen.dart';
import 'guide_screen.dart';
import 'privacy_policy_screen.dart';
import 'settings_screen.dart';

/// 更多页：检测工具、排查指南、隐私承诺、关于。
class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      children: [
        const _ProCard(),
        const _PrivacyCard(),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(l10n.moreTools,
                    style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600)),
              ),
              _ToolTile(
                icon: Icons.auto_fix_high_rounded,
                title: l10n.moreLensTitle,
                subtitle: l10n.moreLensSubtitle,
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LensScreen())),
              ),
              const SizedBox(height: 6),
              _ToolTile(
                icon: Icons.bluetooth_searching_rounded,
                title: l10n.moreBleTitle,
                subtitle: l10n.moreBleSubtitle,
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const BluetoothScreen())),
              ),
              const SizedBox(height: 6),
              _ToolTile(
                icon: Icons.picture_as_pdf_rounded,
                title: l10n.moreReportTitle,
                subtitle: l10n.moreReportSubtitle,
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ReportScreen())),
              ),
              const SizedBox(height: 6),
              _ToolTile(
                icon: Icons.history_rounded,
                title: l10n.moreHistoryTitle,
                subtitle: l10n.moreHistorySubtitle,
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const HistoryScreen())),
              ),
            ],
          ),
        ),
        _NavigableCard(
          icon: Icons.menu_book_rounded,
          title: l10n.moreGuide,
          subtitle: l10n.moreGuideSubtitle,
          onTap: () => Navigator.of(context).push(GuideScreen.route()),
        ),
        _NavigableCard(
          icon: Icons.shield_rounded,
          title: l10n.morePrivacy,
          subtitle: l10n.morePrivacySubtitle,
          onTap: () => Navigator.of(context).push(PrivacyPolicyScreen.route()),
        ),
        _NavigableCard(
          icon: Icons.settings_rounded,
          title: l10n.moreSettings,
          subtitle: l10n.moreSettingsSubtitle,
          onTap: () => Navigator.of(context).push(SettingsScreen.route()),
        ),
        SectionCard(
          child: _Tile(
            icon: Icons.info_outline_rounded,
            title: l10n.moreAbout,
            subtitle: l10n.moreAboutSubtitle,
          ),
        ),
      ],
    );
  }
}

class _ProCard extends StatelessWidget {
  const _ProCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListenableBuilder(
      listenable: ProStore.instance,
      builder: (context, _) {
        final pro = ProStore.instance;
        final remaining = pro.remainingToday;
        return SectionCard(
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  pro.isPro
                      ? Icons.workspace_premium_rounded
                      : Icons.workspace_premium_outlined,
                  color: AppColors.primary,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pro.isPro ? l10n.proUnlocked : l10n.proTitle,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(
                      pro.isPro
                          ? _proDetail(l10n, pro)
                          : l10n.proLimitLeft(remaining),
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              if (pro.isPro)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('PRO',
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700)),
                )
              else
                FilledButton(
                  onPressed: () => ensureAccess(context, consume: false),
                  child: Text(l10n.proUnlock),
                ),
            ],
          ),
        );
      },
    );
  }
  String _proDetail(AppLocalizations l10n, ProStore pro) {
    if (pro.isIapActive) {
      final expiry = pro.iapExpiry;
      final date = expiry == null
          ? ''
          : '${expiry.year}-${expiry.month.toString().padLeft(2, '0')}-${expiry.day.toString().padLeft(2, '0')}';
      final planName = switch (pro.iapPlan) {
        ProPlan.monthly => l10n.proPlanMonthly,
        ProPlan.yearly => l10n.proPlanYearly,
        null => '',
      };
      final base = date.isEmpty ? planName : l10n.proActiveUntil(date);
      return planName.isEmpty ? base : '$planName · $base';
    }
    return l10n.proSubtitle;
  }
}

class _PrivacyCard extends StatelessWidget {
  const _PrivacyCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SectionCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.safe.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lock_rounded, color: AppColors.safe, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.morePrivacyDesign,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  l10n.morePrivacyDesc,
                  style: const TextStyle(
                      fontSize: 12.5, color: AppColors.textSecondary, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolTile extends StatelessWidget {
  const _ToolTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _NavigableCard extends StatelessWidget {
  const _NavigableCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _Tile(icon: icon, title: title, subtitle: subtitle),
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
        ),
        const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
      ],
    );
  }
}
