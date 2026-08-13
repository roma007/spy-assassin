import 'package:flutter/material.dart';

import 'app.dart';
import 'core/locale/locale_store.dart';
import 'core/logging/error_logger.dart';
import 'core/pro/iap_store.dart';
import 'core/pro/pro_store.dart';
import 'core/report/report_archive.dart';
import 'core/stats/stat_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ErrorLogger.instance.install();
  await ProStore.instance.init();
  await IapStore.instance.init();
  await LocaleStore.instance.init();
  await StatStore.instance.init();
  await ReportArchive.instance.init();
  runApp(const PrivacyCameraApp());
}
