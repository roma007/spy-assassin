import 'package:flutter/material.dart';
import 'package:spy_assassin/l10n/app_localizations.dart';

import '../../core/locale/locale_store.dart';
import '../../core/report/report_archive.dart';
import '../../core/stats/stat_store.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_widgets.dart';

/// 设置页：语言切换、本地统计（仅本机）、数据清理。
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const SettingsScreen());

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        children: [
          _LanguageSection(l10n: l10n),
          _StatsSection(l10n: l10n),
          _DataSection(l10n: l10n),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              l10n.settingsDataNote,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageSection extends StatelessWidget {
  const _LanguageSection({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LocaleStore.instance,
      builder: (context, _) {
        final current = LocaleStore.instance.language;
        final options = [
          (AppLanguage.system, l10n.settingsLanguageSystem),
          (AppLanguage.zh, l10n.settingsLanguageZh),
          (AppLanguage.en, l10n.settingsLanguageEn),
          (AppLanguage.ko, l10n.settingsLanguageKo),
          (AppLanguage.es, l10n.settingsLanguageEs),
        ];
        return SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionLabel(l10n.settingsLanguage),
              for (final (lang, label) in options) ...[
                _SelectTile(
                  label: label,
                  selected: lang == current,
                  onTap: () => LocaleStore.instance.setLanguage(lang),
                ),
                if (lang != options.last.$1) const SizedBox(height: 4),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _StatsSection extends StatelessWidget {
  const _StatsSection({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: StatStore.instance,
      builder: (context, _) {
        final stats = StatStore.instance;
        final rows = [
          (l10n.statsCheckStarted, '${stats.checkStarted}'),
          (l10n.statsCheckDone, '${stats.checkDone}'),
          (l10n.statsCompletionRate,
              '${(stats.completionRate * 100).round()}%'),
          (l10n.statsAvgDuration, _formatMs(stats.averageCheckMs, l10n)),
        ];
        final toolRows = [
          (l10n.featureIr, stats.irCount),
          (l10n.featureLens, stats.lensCount),
          (l10n.featureWifi, stats.wifiCount),
          (l10n.featureMagnet, stats.magnetCount),
          (l10n.featureBluetooth, stats.bleCount),
          (l10n.featureTracker, stats.trackerCount),
        ];
        final empty = stats.checkStarted == 0 &&
            toolRows.every((r) => r.$2 == 0);
        return SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionLabel(l10n.settingsStatsTitle),
              if (empty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(l10n.statsEmpty,
                      style: const TextStyle(
                          fontSize: 12.5,
                          color: AppColors.textSecondary,
                          height: 1.5)),
                )
              else ...[
                for (final (label, value) in rows)
                  _StatRow(label: label, value: value),
                const SizedBox(height: 6),
                Text(l10n.statsTools,
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                for (final (label, value) in toolRows)
                  _StatRow(label: label, value: '$value'),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _DataSection extends StatelessWidget {
  const _DataSection({required this.l10n});

  final AppLocalizations l10n;

  Future<void> _confirm(
      BuildContext context, String title, VoidCallback onConfirm) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(l10n.settingsClearConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.settingsCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.settingsClearDone),
          ),
        ],
      ),
    );
    if (confirmed == true) onConfirm();
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(l10n.settingsDataTitle),
          _SelectTile(
            label: l10n.settingsClearStats,
            onTap: () => _confirm(context, l10n.settingsClearStats,
                StatStore.instance.clear),
          ),
          const SizedBox(height: 4),
          _SelectTile(
            label: l10n.settingsClearReport,
            onTap: () => _confirm(context, l10n.settingsClearReport,
                ReportArchive.instance.clearAll),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600)),
    );
  }
}

class _SelectTile extends StatelessWidget {
  const _SelectTile({
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(label,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
            ),
            Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.circle_outlined,
              color: selected ? AppColors.primary : AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    fontSize: 13.5, color: AppColors.textSecondary)),
          ),
          Text(value,
              style: const TextStyle(
                  fontSize: 13.5, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

String _formatMs(int ms, AppLocalizations l10n) {
  if (ms <= 0) return '--';
  final totalSeconds = ms ~/ 1000;
  final m = totalSeconds ~/ 60;
  final s = totalSeconds % 60;
  return l10n.statsDurationFormat(m, s);
}
