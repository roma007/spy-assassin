import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 用户可选语言。null 表示跟随系统。
enum AppLanguage {
  system,
  zh,
  en,
  ko;

  String get storageValue => name;

  Locale? get locale => switch (this) {
        AppLanguage.system => null,
        AppLanguage.zh => const Locale('zh', 'CN'),
        AppLanguage.en => const Locale('en', 'US'),
        AppLanguage.ko => const Locale('ko', 'KR'),
      };
}

/// App 语言设置（仅本机保存，不上传）。
class LocaleStore extends ChangeNotifier {
  LocaleStore._();

  static final LocaleStore instance = LocaleStore._();

  static const _key = 'app_locale';

  AppLanguage _language = AppLanguage.system;

  AppLanguage get language => _language;

  Locale? get locale => _language.locale;

  Future<void> setLanguage(AppLanguage language) async {
    if (language == _language) return;
    _language = language;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, language.storageValue);
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw != null) {
      _language = AppLanguage.values.firstWhere(
        (l) => l.storageValue == raw,
        orElse: () => AppLanguage.system,
      );
    }
    notifyListeners();
  }
}
