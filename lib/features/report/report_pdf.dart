import 'package:flutter/material.dart' show decodeImageFromList;
import 'package:flutter/services.dart';
import 'package:spy_assassin/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/l10n/app_localizations_ext.dart';
import '../../core/report/report_store.dart';

/// 生成本地化检测报告 PDF（矢量文字，内嵌 NotoSansSC 子集字体）。
class ReportPdf {
  ReportPdf._();

  static const _fontAsset = 'assets/fonts/NotoSansSC-Subset.ttf';
  static const _fontAssetKo = 'assets/fonts/NotoSansKR-Subset.ttf';

  static const _pageWidth = 595.0; // A4 宽（pt）
  static const _pagePadding = 36.0;
  static const _photoMaxWidth = 460.0;
  static const _photoMaxHeight = 300.0;

  static pw.Font? _cachedFont;
  static String? _cachedLocale;

  static Future<pw.Font> _loadFont(String locale) async {
    if (_cachedFont != null && _cachedLocale == locale) return _cachedFont!;
    final fontData = await rootBundle
        .load(locale == 'ko' ? _fontAssetKo : _fontAsset);
    _cachedFont = pw.Font.ttf(fontData);
    _cachedLocale = locale;
    return _cachedFont!;
  }

  /// 生成 PDF 字节流；本地生成，不落服务器。
  /// [font] 可选，用于测试或自定义字体场景。
  static Future<Uint8List> build({
    required AppLocalizations l10n,
    required String place,
    required List<ReportEntry> entries,
    List<Uint8List> photos = const [],
    pw.Font? font,
  }) async {
    final resolvedFont = font ?? await _loadFont(l10n.localeName);

    final doc = pw.Document(title: l10n.reportPdfTitle);
    final dateFmt = DateFormat('yyyy-MM-dd HH:mm');
    final riskCount = entries.where((e) => e.risk != ReportRisk.safe).length;
    final photoWidgets = <pw.Widget>[];
    for (final bytes in photos) {
      final block = await _photoBlock(bytes);
      if (block != null) photoWidgets.add(block);
    }

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: resolvedFont),
        footer: (context) => pw.Text(
          l10n.reportPdfFooter,
          style: const pw.TextStyle(
              fontSize: 8, color: PdfColor.fromInt(0xFF93A1B8)),
          textAlign: pw.TextAlign.center,
        ),
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Row(
              children: [
                pw.Text(l10n.reportPdfTitle,
                    style: pw.TextStyle(
                        fontSize: 20, fontWeight: pw.FontWeight.bold)),
              ],
            ),
          ),
          pw.SizedBox(height: 8),
          _kv(l10n.reportPdfTime, dateFmt.format(DateTime.now())),
          _kv(l10n.reportPdfPlace,
              place.isEmpty ? l10n.reportPdfPlaceEmpty : place),
          for (final e in entries)
            if (e.wifiName != null)
              _kv(l10n.reportPdfWifi,
                  e.wifiName!.isEmpty ? l10n.reportPdfWifiEmpty : e.wifiName!),
          pw.SizedBox(height: 12),
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromInt(0xFF161E2E),
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Text(
              l10n.reportPdfSummary(entries.length, riskCount),
              style: pw.TextStyle(
                  fontSize: 11,
                  color: PdfColor.fromInt(0xFFE8EDF6),
                  fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 16),
          if (entries.isEmpty)
            pw.Text(l10n.reportPdfEmpty,
                style: const pw.TextStyle(fontSize: 12))
          else
            for (final e in entries)
              _entryBlock(l10n, e, dateFmt),
          if (photoWidgets.isNotEmpty) ...[
            pw.SizedBox(height: 16),
            pw.Text(l10n.reportPdfPhotos,
                style: pw.TextStyle(
                    fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 6),
            for (final w in photoWidgets) w,
          ],
          pw.SizedBox(height: 16),
          pw.Text(l10n.reportPdfNext,
              style: pw.TextStyle(
                  fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 6),
          for (final s in [
            l10n.reportPdfAction1,
            l10n.reportPdfAction2,
            l10n.reportPdfAction3,
          ])
            pw.Text('• $s',
                style: const pw.TextStyle(fontSize: 11, height: 1.6)),
          pw.SizedBox(height: 16),
          pw.Text(
            l10n.reportPdfDisclaimer,
            style: const pw.TextStyle(
                fontSize: 8.5, color: PdfColor.fromInt(0xFF93A1B8), height: 1.5),
          ),
        ],
      ),
    );
    return doc.save();
  }

  /// 将照片字节解码并按 A4 内容区比例缩放（不跨页）。
  static Future<pw.Widget?> _photoBlock(Uint8List bytes) async {
    try {
      final img = await decodeImageFromList(bytes);
      final width = img.width.toDouble();
      final height = img.height.toDouble();
      if (width <= 0 || height <= 0) return null;
      final ratio = width / height;
      final available = _pageWidth - _pagePadding * 2;
      final maxW = _photoMaxWidth.clamp(0.0, available).toDouble();
      var w = maxW;
      var h = w / ratio;
      if (h > _photoMaxHeight) {
        h = _photoMaxHeight;
        w = h * ratio;
      }
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 4),
        child: pw.Image(pw.MemoryImage(bytes), width: w, height: h),
      );
    } catch (_) {
      return null;
    }
  }

  static pw.Widget _kv(String k, String v) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.SizedBox(
              width: 90,
              child: pw.Text(k,
                  style: const pw.TextStyle(
                      fontSize: 11, color: PdfColor.fromInt(0xFF93A1B8))),
            ),
            pw.Expanded(
              child: pw.Text(v, style: const pw.TextStyle(fontSize: 11)),
            ),
          ],
        ),
      );

  static pw.Widget _entryBlock(
      AppLocalizations l10n, ReportEntry e, DateFormat dateFmt) {
    final (label, color, tint) = switch (e.risk) {
      ReportRisk.safe => (
          l10n.riskSafe,
          const PdfColor.fromInt(0xFF3DD68C),
          const PdfColor.fromInt(0x263DD68C)
        ),
      ReportRisk.low => (
          l10n.riskLow,
          const PdfColor.fromInt(0xFFE8B93A),
          const PdfColor.fromInt(0x26E8B93A)
        ),
      ReportRisk.high => (
          l10n.riskHigh,
          const PdfColor.fromInt(0xFFE5484D),
          const PdfColor.fromInt(0x26E5484D)
        ),
    };
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8),
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: const PdfColor.fromInt(0xFF26324A)),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Expanded(
                child: pw.Text(l10n.featureTitle(e.featureKey),
                    style: pw.TextStyle(
                        fontSize: 12, fontWeight: pw.FontWeight.bold)),
              ),
              pw.Container(
                padding:
                    const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: pw.BoxDecoration(
                  color: tint,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Text(label,
                    style: pw.TextStyle(fontSize: 10, color: color)),
              ),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Text(dateFmt.format(e.time),
              style: const pw.TextStyle(
                  fontSize: 9, color: PdfColor.fromInt(0xFF93A1B8))),
          pw.SizedBox(height: 4),
          pw.Text(e.summary,
              style: const pw.TextStyle(fontSize: 10.5, height: 1.5)),
        ],
      ),
    );
  }
}
