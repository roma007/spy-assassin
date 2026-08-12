import 'package:flutter/material.dart';
import 'package:privacy_camera/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import '../../core/l10n/app_localizations_ext.dart';
import '../../core/pro/upgrade_dialog.dart';
import '../../core/report/report_archive.dart';
import '../../core/report/report_store.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_widgets.dart';
import 'history_screen.dart';
import 'report_pdf.dart';

/// 检测报告页：汇总本次会话的各检测项结论，导出 PDF 分享（取证场景）。
class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _placeCtrl = TextEditingController();
  bool _exporting = false;
  bool _sealing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _placeCtrl.text = ReportStore.instance.place;
  }

  @override
  void dispose() {
    _placeCtrl.dispose();
    super.dispose();
  }

  Future<void> _seal() async {
    if (_sealing) return;
    setState(() {
      _sealing = true;
      _error = null;
    });
    await ReportArchive.instance.seal();
    if (mounted) setState(() => _sealing = false);
  }

  Future<void> _export() async {
    if (_exporting) return;
    final l10n = AppLocalizations.of(context)!;
    if (!await ensureAccess(context, consume: false)) return;
    final entries = ReportStore.instance.entries;
    if (entries.isEmpty) {
      setState(() => _error = l10n.reportEmptyError);
      return;
    }
    setState(() {
      _exporting = true;
      _error = null;
    });
    try {
      final bytes = await ReportPdf.build(
        l10n: l10n,
        place: _placeCtrl.text.trim(),
        entries: entries,
        photos: ReportStore.instance.photos,
      );
      final ts = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
      final ok = await Printing.sharePdf(
        bytes: bytes,
        filename: 'privacy_camera_report_$ts.pdf',
        subject: l10n.reportPdfTitle,
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

  Future<void> _pickPhoto() async {
    final l10n = AppLocalizations.of(context)!;
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(l10n.reportAddPhoto,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_rounded),
              title: Text(l10n.reportAddPhotoCamera),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: Text(l10n.reportAddPhotoGallery),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (source == null) return;
    try {
      final picker = ImagePicker();
      final shot = await picker.pickImage(source: source, maxWidth: 1600);
      if (shot == null) return;
      final bytes = await shot.readAsBytes();
      ReportStore.instance.addPhoto(bytes);
    } catch (_) {
      if (mounted) setState(() => _error = l10n.reportPhotoFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.reportTitle)),
      body: ListenableBuilder(
        listenable: ReportStore.instance,
        builder: (context, _) {
          final entries = ReportStore.instance.entries;
          final riskCount = ReportStore.instance.riskCount;
          return ListView(
            padding: const EdgeInsets.only(top: 8, bottom: 24),
            children: [
              _buildSummary(l10n, entries.length, riskCount),
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(l10n.reportHistoryTitle,
                            style: const TextStyle(
                                fontSize: 12.5,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600)),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => const HistoryScreen())),
                          icon: const Icon(Icons.history_rounded, size: 18),
                          label: Text(l10n.reportOpenHistory),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _placeCtrl,
                      onChanged: (v) => ReportStore.instance.place = v,
                      decoration: InputDecoration(
                        labelText: l10n.reportPlaceLabel,
                        hintText: l10n.reportPlaceHint,
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ],
                ),
              ),
              _buildPhotos(l10n),
              if (_error != null)
                SectionCard(
                  child: Row(
                    children: [
                      Icon(Icons.info_outline_rounded,
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
              if (entries.isEmpty)
                SectionCard(
                  child: Text(
                    l10n.reportEmptyHint,
                    style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                        height: 1.5),
                  ),
                )
              else
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(l10n.reportDetails,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600)),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              ReportStore.instance.clear();
                              setState(() => _error = null);
                            },
                            child: Text(l10n.reportClear),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      for (final e in entries) _EntryTile(entry: e),
                    ],
                  ),
                ),
              SectionCard(
                child: FilledButton.icon(
                  onPressed: _exporting ? null : _export,
                  icon: _exporting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.picture_as_pdf_rounded),
                  label: Text(_exporting ? l10n.reportExporting : l10n.reportExportPdf),
                ),
              ),
              if (entries.isNotEmpty)
                SectionCard(
                  child: OutlinedButton.icon(
                    onPressed: _sealing ? null : _seal,
                    icon: _sealing
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: AppColors.primary),
                          )
                        : const Icon(Icons.archive_rounded),
                    label: Text(l10n.reportSeal),
                  ),
                ),
              SectionCard(
                child: Text(
                  l10n.reportLocalNote,
                  style: const TextStyle(
                      fontSize: 11.5, color: AppColors.textSecondary, height: 1.5),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPhotos(AppLocalizations l10n) {
    final photos = ReportStore.instance.photos;
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(l10n.reportPhotos,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
              const Spacer(),
              TextButton.icon(
                onPressed: _pickPhoto,
                icon: const Icon(Icons.add_photo_alternate_rounded, size: 18),
                label: Text(l10n.reportAddPhoto),
              ),
            ],
          ),
          if (photos.isEmpty)
            Text(
              l10n.reportPhotosEmpty,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary),
            )
          else
            SizedBox(
              height: 92,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: photos.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, i) => Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.memory(
                        photos[i],
                        width: 92,
                        height: 92,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => ReportStore.instance.removePhoto(i),
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.55),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close_rounded,
                              size: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummary(
      AppLocalizations l10n, int count, int riskCount) {
    return SectionCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: (riskCount > 0 ? AppColors.riskHigh : AppColors.safe)
                  .withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              riskCount > 0
                  ? Icons.warning_amber_rounded
                  : Icons.verified_rounded,
              color: riskCount > 0 ? AppColors.riskHigh : AppColors.safe,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.reportSummary(count, riskCount),
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(l10n.reportSummaryDesc,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EntryTile extends StatelessWidget {
  const _EntryTile({required this.entry});

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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(l10n.featureTitle(entry.featureKey),
                    style: const TextStyle(
                        fontSize: 13.5, fontWeight: FontWeight.w600)),
              ),
              RiskChip(label: label, color: color),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('MM-dd HH:mm').format(entry.time),
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(entry.summary,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textPrimary, height: 1.5)),
        ],
      ),
    );
  }
}
