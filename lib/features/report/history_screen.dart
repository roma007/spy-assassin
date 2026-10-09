import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spy_assassin/l10n/app_localizations.dart';

import '../../core/pro/pro_store.dart';
import '../../core/report/report_archive.dart';
import '../../core/report/report_store.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_widgets.dart';
import 'report_screen.dart';

/// 扫描历史页：本地持久化的检查记录列表，可打开/删除。
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<ReportRecord> _records = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final records = await ReportArchive.instance.loadAll();
    if (!mounted) return;
    setState(() {
      _records = records;
      _loading = false;
    });
  }

  Future<void> _open(ReportRecord r) async {
    await ReportArchive.instance.loadInto(r);
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ReportScreen()),
    );
    _load();
  }

  Future<void> _delete(ReportRecord r) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.delete_rounded, color: AppColors.riskHigh),
        title: Text(l10n.historyDelete),
        content: Text(l10n.historyDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.settingsCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.riskHigh),
            child: Text(l10n.historyDelete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ReportArchive.instance.deleteRecord(r.id);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.historyTitle)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              children: [
                if (!ProStore.instance.isPro) ...[
                  const SizedBox(height: 4),
                  ListenableBuilder(
                    listenable: ProStore.instance,
                    builder: (context, _) => SectionCard(
                      child: Row(
                        children: [
                          const Icon(Icons.workspace_premium_outlined,
                              color: AppColors.primary, size: 22),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              ProStore.instance.isPro
                                  ? l10n.historyProUnlimited
                                  : l10n.historyProNote(ReportArchive.freeKeepCount),
                              style: const TextStyle(
                                  fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                if (_records.isEmpty)
                  SectionCard(
                    child: Text(
                      l10n.historyEmpty,
                      style: const TextStyle(
                          fontSize: 12.5,
                          color: AppColors.textSecondary,
                          height: 1.5),
                    ),
                  )
                else
                  for (final r in _records)
                    _HistoryCard(
                      record: r,
                      onOpen: () => _open(r),
                      onDelete: () => _delete(r),
                    ),
              ],
            ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({
    required this.record,
    required this.onOpen,
    required this.onDelete,
  });

  final ReportRecord record;
  final VoidCallback onOpen;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final riskCount = record.riskCount;
    final hasHigh =
        record.entries.any((e) => e.risk == ReportRisk.high);
    final (label, color) = hasHigh
        ? (l10n.riskHigh, AppColors.riskHigh)
        : riskCount > 0
            ? (l10n.riskLow, AppColors.riskLow)
            : (l10n.riskSafe, AppColors.safe);
    return SectionCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    hasHigh
                        ? Icons.warning_amber_rounded
                        : riskCount > 0
                            ? Icons.help_rounded
                            : Icons.verified_rounded,
                    color: color,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      DateFormat('yyyy-MM-dd HH:mm').format(record.createdAt),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                  RiskChip(label: label, color: color),
                ],
              ),
              if (record.place.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.historyPlace(record.place),
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
              const SizedBox(height: 6),
              Text(
                l10n.reportSummary(record.entries.length, riskCount),
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
              if (record.photoPaths.isNotEmpty) ...[
                const SizedBox(height: 10),
                SizedBox(
                  height: 64,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: record.photoPaths.length > 4
                        ? 4
                        : record.photoPaths.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, i) => ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(record.photoPaths[i]),
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: onOpen,
                    icon: const Icon(Icons.open_in_new_rounded, size: 16),
                    label: Text(l10n.historyOpen),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline_rounded, size: 16),
                    label: Text(l10n.historyDelete),
                    style: TextButton.styleFrom(
                        foregroundColor: AppColors.riskHigh),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
