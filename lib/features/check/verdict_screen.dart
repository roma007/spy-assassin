import 'package:flutter/material.dart';
import 'package:spy_assassin/l10n/app_localizations.dart';
import 'package:printing/printing.dart';

import '../../core/l10n/app_localizations_ext.dart';
import '../../core/report/report_store.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_widgets.dart';
import '../report/report_pdf.dart';
import '../report/report_screen.dart';
import 'next_actions_screen.dart';

/// 扫描结论页：即时红/绿结论 + 证据明细（保留证据流） + PDF 导出 + 下一步行动。
class VerdictScreen extends StatefulWidget {
  const VerdictScreen({super.key});

  @override
  State<VerdictScreen> createState() => _VerdictScreenState();
}

class _VerdictScreenState extends State<VerdictScreen> {
  bool _exporting = false;
  bool _showEvidence = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final entries = ReportStore.instance.entries;
    final riskCount = entries.where((e) => e.risk != ReportRisk.safe).length;
    final highCount = entries.where((e) => e.risk == ReportRisk.high).length;
    final isSafe = riskCount == 0;
    final isHighRisk = highCount > 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.verdictTitle),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 结论大卡：红/绿
          _VerdictCard(
            isSafe: isSafe,
            isHighRisk: isHighRisk,
            riskCount: riskCount,
            highCount: highCount,
            l10n: l10n,
          ),
          const SizedBox(height: 16),
          // 证据明细（可展开/折叠）
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(l10n.verdictViewEvidence,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    IconButton(
                      icon: Icon(_showEvidence
                          ? Icons.expand_less_rounded
                          : Icons.expand_more_rounded),
                      onPressed: () => setState(() => _showEvidence = !_showEvidence),
                    ),
                  ],
                ),
                if (_showEvidence) ...[
                  const SizedBox(height: 8),
                  if (entries.isEmpty)
                    Text(l10n.reportEmptyHint,
                        style: const TextStyle(
                            fontSize: 12.5, color: AppColors.textSecondary))
                  else
                    ...entries.map((e) => _EvidenceTile(entry: e)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          // 操作按钮
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _exporting ? null : _exportPdf,
                  icon: _exporting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.picture_as_pdf_rounded),
                  label: Text(_exporting ? l10n.reportExporting : l10n.verdictExportPdf),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const NextActionsScreen()),
                  ),
                  icon: const Icon(Icons.health_and_safety_rounded),
                  label: Text(l10n.verdictNextActions),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.riskHigh,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_error != null)
            SectionCard(
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      color: AppColors.textSecondary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(_error!,
                        style: const TextStyle(
                            fontSize: 12.5,
                            color: AppColors.textSecondary)),
                  ),
                ],
              ),
            ),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const ReportScreen()),
              ),
              child: Text(l10n.verdictDone),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportPdf() async {
    if (_exporting) return;
    final l10n = AppLocalizations.of(context)!;
    final entries = ReportStore.instance.entries;
    if (entries.isEmpty) return;
    setState(() {
      _exporting = true;
      _error = null;
    });
    try {
      final bytes = await ReportPdf.build(
        l10n: l10n,
        place: '',
        entries: entries,
        photos: ReportStore.instance.photos,
      );
      final ok = await Printing.sharePdf(
        bytes: bytes,
        filename: 'spy_assassin_report_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
      if (!ok && mounted) {
        setState(() => _error = l10n.reportShareCancelled);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = l10n.reportExportFailed('$e'));
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }
}

class _VerdictCard extends StatelessWidget {
  const _VerdictCard({
    required this.isSafe,
    required this.isHighRisk,
    required this.riskCount,
    required this.highCount,
    required this.l10n,
  });

  final bool isSafe;
  final bool isHighRisk;
  final int riskCount;
  final int highCount;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isSafe ? AppColors.safe.withValues(alpha: 0.12) : AppColors.riskHigh.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSafe ? AppColors.safe : AppColors.riskHigh,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(
            isSafe ? Icons.verified_rounded : Icons.warning_amber_rounded,
            size: 56,
            color: isSafe ? AppColors.safe : AppColors.riskHigh,
          ),
          const SizedBox(height: 12),
          Text(
            isSafe ? l10n.verdictSafe : (isHighRisk ? l10n.verdictHighRisk : l10n.verdictRisk(riskCount)),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isSafe ? AppColors.safe : AppColors.riskHigh,
            ),
            textAlign: TextAlign.center,
          ),
          if (!isSafe) ...[
            const SizedBox(height: 8),
            Text(
              l10n.wifiRiskCounts(highCount, riskCount - highCount),
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}

class _EvidenceTile extends StatelessWidget {
  const _EvidenceTile({required this.entry});

  final ReportEntry entry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final (label, color) = switch (entry.risk) {
      ReportRisk.safe => (l10n.riskSafe, AppColors.safe),
      ReportRisk.low => (l10n.riskLow, AppColors.riskLow),
      ReportRisk.high => (l10n.riskHigh, AppColors.riskHigh),
    };
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(l10n.featureTitle(entry.featureKey),
                  style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
              const Spacer(),
              RiskChip(label: label, color: color),
            ],
          ),
          const SizedBox(height: 4),
          Text(entry.summary,
              style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, height: 1.4)),
        ],
      ),
    );
  }
}