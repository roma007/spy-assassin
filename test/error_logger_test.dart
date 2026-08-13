import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:privacy_camera/core/logging/error_logger.dart';

void main() {
  late Directory tempDir;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('error_logger_test');
    ErrorLogger.overrideRootDir = tempDir.path;
  });

  tearDown(() {
    ErrorLogger.overrideRootDir = null;
    try {
      tempDir.deleteSync(recursive: true);
    } catch (_) {}
  });

  test('log writes a file under error_logs with content', () async {
    await ErrorLogger.instance.log('boom', stack: 'line 1\nline 2');

    final dir = Directory('${tempDir.path}/error_logs');
    expect(dir.existsSync(), isTrue);
    final files = dir.listSync().whereType<File>().toList();
    expect(files, hasLength(1));

    final content = File(files.single.path).readAsStringSync();
    expect(content, contains('boom'));
    expect(content, contains('line 1'));
    expect(content, contains('---'));
  });

  test('log without stack writes message only', () async {
    await ErrorLogger.instance.log('plain');

    final dir = Directory('${tempDir.path}/error_logs');
    final files = dir.listSync().whereType<File>().toList();
    final content = File(files.single.path).readAsStringSync();
    expect(content, contains('plain'));
  });

  test('install/dispose restores previous handlers', () {
    final prevFlutter = FlutterError.onError;
    final prevPlatform = PlatformDispatcher.instance.onError;

    expect(ErrorLogger.instance.install(), isTrue);
    expect(ErrorLogger.instance.install(), isFalse, reason: '重复安装无效');

    ErrorLogger.instance.dispose();
    expect(FlutterError.onError, same(prevFlutter));
    expect(PlatformDispatcher.instance.onError, same(prevPlatform));
  });

  test('readAll concatenates recent logs', () async {
    await ErrorLogger.instance.log('first');
    await ErrorLogger.instance.log('second');

    final all = await ErrorLogger.instance.readAll();
    expect(all, contains('first'));
    expect(all, contains('second'));
  });
}
