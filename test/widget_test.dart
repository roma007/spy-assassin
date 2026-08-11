import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:privacy_camera/app.dart';
import 'package:privacy_camera/core/pro/pro_store.dart';

void main() {
  testWidgets('App boots and shows bottom navigation', (tester) async {
    tester.binding.platformDispatcher.localesTestValue = const [
      Locale('zh', 'CN'),
    ];
    await tester.pumpWidget(const PrivacyCameraApp());

    expect(find.text('房间检查'), findsOneWidget);
    expect(find.text('检查'), findsOneWidget);
    expect(find.text('红外'), findsOneWidget);
    expect(find.text('WiFi'), findsOneWidget);
    expect(find.text('磁力'), findsOneWidget);
    expect(find.text('更多'), findsOneWidget);
  });

  testWidgets('App shows English UI under en locale', (tester) async {
    tester.binding.platformDispatcher.localesTestValue = const [
      Locale('en', 'US'),
    ];
    await tester.pumpWidget(const PrivacyCameraApp());

    expect(find.text('Room Check'), findsOneWidget);
    expect(find.text('Check'), findsOneWidget);
    expect(find.text('IR'), findsOneWidget);
    expect(find.text('WiFi'), findsOneWidget);
    expect(find.text('Magnet'), findsOneWidget);
    expect(find.text('More'), findsOneWidget);
  });

  testWidgets('App shows Korean UI under ko locale', (tester) async {
    tester.binding.platformDispatcher.localesTestValue = const [
      Locale('ko', 'KR'),
    ];
    await tester.pumpWidget(const PrivacyCameraApp());

    expect(find.text('방 점검'), findsOneWidget);
    expect(find.text('점검'), findsOneWidget);
    expect(find.text('적외선'), findsOneWidget);
    expect(find.text('자력'), findsOneWidget);
    expect(find.text('더보기'), findsOneWidget);
  });

  testWidgets('Settings entry opens from More tab', (tester) async {
    ProStore.instance.unlock();
    tester.binding.platformDispatcher.localesTestValue = const [
      Locale('zh', 'CN'),
    ];
    await tester.pumpWidget(const PrivacyCameraApp());

    await tester.tap(find.text('更多'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    await tester.dragUntilVisible(
      find.text('设置'),
      find.text('检测报告'),
      const Offset(0, -200),
    );
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('设置'), findsWidgets);

    await tester.tap(find.text('设置').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('语言'), findsOneWidget);
    expect(find.text('本地统计'), findsOneWidget);
    expect(find.text('跟随系统'), findsOneWidget);
    expect(find.text('简体中文'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('한국어'), findsOneWidget);
  });
}
