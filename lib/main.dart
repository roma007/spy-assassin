import 'package:flutter/material.dart';

import 'app.dart';
import 'core/locale/locale_store.dart';
import 'core/pro/pro_store.dart';
import 'core/stats/stat_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ProStore.instance.init();
  await LocaleStore.instance.init();
  await StatStore.instance.init();
  runApp(const PrivacyCameraApp());
}
