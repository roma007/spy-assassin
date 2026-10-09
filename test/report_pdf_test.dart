import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:spy_assassin/core/report/report_store.dart';
import 'package:spy_assassin/features/report/report_pdf.dart';
import 'package:spy_assassin/l10n/app_localizations_en.dart';

/// 从项目 assets 目录加载 NotoSansSC 字体用于测试。
Future<pw.Font> _loadTestFont() async {
  final file = File('assets/fonts/NotoSansSC-Subset.ttf');
  final bytes = await file.readAsBytes();
  return pw.Font.ttf(ByteData.view(bytes.buffer));
}

void main() {
  final l10n = AppLocalizationsEn();

  late pw.Font testFont;

  setUpAll(() async {
    testFont = await _loadTestFont();
  });

  group('ReportPdf.build', () {
    test('空条目生成合法 PDF', () async {
      final bytes = await ReportPdf.build(
        l10n: l10n,
        place: '',
        entries: [],
        font: testFont,
      );
      expect(bytes, isNotEmpty);
      expect(_isPdf(bytes), isTrue);
    });

    test('含条目生成合法 PDF', () async {
      final entries = [
        ReportEntry(
          featureKey: 'ir',
          time: DateTime(2026, 8, 15, 10, 30),
          risk: ReportRisk.safe,
          summary: 'No IR source detected',
        ),
        ReportEntry(
          featureKey: 'wifi',
          time: DateTime(2026, 8, 15, 10, 31),
          risk: ReportRisk.high,
          summary: 'Suspicious device found on network',
          wifiName: 'Hotel_WiFi',
        ),
      ];
      final bytes = await ReportPdf.build(
        l10n: l10n,
        place: 'Room 1208',
        entries: entries,
        font: testFont,
      );
      expect(bytes, isNotEmpty);
      expect(_isPdf(bytes), isTrue);
    });

    test('三种风险等级均可生成', () async {
      final entries = [
        ReportEntry(
          featureKey: 'lens',
          time: DateTime(2026, 8, 15),
          risk: ReportRisk.safe,
          summary: 'Clean',
        ),
        ReportEntry(
          featureKey: 'bluetooth',
          time: DateTime(2026, 8, 15),
          risk: ReportRisk.low,
          summary: 'Uncertain BT device',
        ),
        ReportEntry(
          featureKey: 'magnet',
          time: DateTime(2026, 8, 15),
          risk: ReportRisk.high,
          summary: 'Strong magnetic anomaly',
        ),
      ];
      final bytes = await ReportPdf.build(
        l10n: l10n,
        place: '',
        entries: entries,
        font: testFont,
      );
      expect(_isPdf(bytes), isTrue);
    });

    test('WiFi 名称为空时不崩溃', () async {
      final entries = [
        ReportEntry(
          featureKey: 'wifi',
          time: DateTime(2026, 8, 15),
          risk: ReportRisk.low,
          summary: 'No WiFi info',
          wifiName: '',
        ),
      ];
      final bytes = await ReportPdf.build(
        l10n: l10n,
        place: 'Test',
        entries: entries,
        font: testFont,
      );
      expect(_isPdf(bytes), isTrue);
    });
  });
}

bool _isPdf(Uint8List bytes) {
  if (bytes.length < 5) return false;
  return bytes[0] == 0x25 && // %
      bytes[1] == 0x50 && // P
      bytes[2] == 0x44 && // D
      bytes[3] == 0x46; // F
}
