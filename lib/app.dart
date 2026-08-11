import 'package:flutter/material.dart';
import 'package:privacy_camera/l10n/app_localizations.dart';

import 'core/locale/locale_store.dart';
import 'core/theme/app_theme.dart';
import 'features/home/home_shell.dart';

class PrivacyCameraApp extends StatefulWidget {
  const PrivacyCameraApp({super.key});

  @override
  State<PrivacyCameraApp> createState() => _PrivacyCameraAppState();
}

class _PrivacyCameraAppState extends State<PrivacyCameraApp> {
  @override
  void initState() {
    super.initState();
    LocaleStore.instance.addListener(_onLocaleChanged);
  }

  @override
  void dispose() {
    LocaleStore.instance.removeListener(_onLocaleChanged);
    super.dispose();
  }

  void _onLocaleChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      locale: LocaleStore.instance.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomeShell(),
    );
  }
}
