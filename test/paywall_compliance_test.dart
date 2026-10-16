import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spy_assassin/core/pro/upgrade_dialog.dart';
import 'package:spy_assassin/l10n/app_localizations.dart';

/// 付费墙合规要素（App 审核指南 3.1.2）：
/// 订阅周期、自动续费说明、使用条款（EULA）与隐私政策链接、恢复购买。
Future<void> _pumpPaywall(WidgetTester tester, Locale locale) async {
  await tester.pumpWidget(MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: const Scaffold(body: PaywallDialog()),
  ));
  await tester.pump();
}

void main() {
  const locales = [
    Locale('en'),
    Locale('zh'),
    Locale('ko'),
    Locale('es'),
  ];

  for (final locale in locales) {
    testWidgets('付费墙展示订阅合规要素（${locale.languageCode}）',
        (tester) async {
      await _pumpPaywall(tester, locale);
      final l10n = await AppLocalizations.delegate.load(locale);

      // 订阅周期（长度）+ 自动续费。
      expect(find.text(l10n.proPlanMonthlySub), findsOneWidget);
      expect(find.text(l10n.proPlanYearlySub), findsOneWidget);
      expect(find.text(l10n.proRenewalNote), findsOneWidget);

      // 使用条款（EULA）与隐私政策链接。
      expect(find.text(l10n.proTermsOfUse), findsOneWidget);
      expect(find.text(l10n.proPrivacyPolicy), findsOneWidget);

      // 恢复购买。
      expect(find.text(l10n.proRestore), findsOneWidget);
    });
  }

  testWidgets('合规链接指向苹果标准 EULA 与本站隐私政策', (tester) async {
    expect(kTermsOfUseUrl, 'https://www.apple.com/legal/internet-services/'
        'itunes/dev/stdeula/');
    expect(kPrivacyPolicyUrl, 'https://roma007.github.io/spy-assassin/'
        'privacy.html');
  });

  testWidgets('付费墙文案不再宣称「送 2 个月」', (tester) async {
    for (final locale in locales) {
      final l10n = await AppLocalizations.delegate.load(locale);
      expect(l10n.proPlanYearlySub.toLowerCase(), isNot(contains('2 month')));
      expect(l10n.proPlanYearlySub, isNot(contains('2 个月')));
      expect(l10n.proPlanYearlySub, isNot(contains('2개월')));
      expect(l10n.proPlanYearlySub.toLowerCase(), isNot(contains('2 meses')));
    }
  });
}
