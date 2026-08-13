import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// 全局异常捕获：把 Flutter 框架错误与未捕获异步异常统一落盘。
/// - 按天一个文件 `error_logs/error_yyyyMMdd.log`，保留最近 [maxKeepFiles] 份
/// - 日志只写在设备本地，数据不出 App
/// - 注册前先保存旧 handler，可 [dispose] 恢复（测试用）
class ErrorLogger {
  ErrorLogger._();

  static final ErrorLogger instance = ErrorLogger._();

  static const int maxKeepFiles = 10;
  static const String _dirName = 'error_logs';

  /// 测试用：覆盖根目录，避免真实应用目录。
  @visibleForTesting
  static String? overrideRootDir;

  bool _installed = false;
  FlutterExceptionHandler? _prevFlutter;
  bool Function(Object error, StackTrace stack)? _prevPlatform;

  /// 注册全局异常处理器。重复调用无效，返回是否首次安装。
  bool install() {
    if (_installed) return false;
    _installed = true;
    _prevFlutter = FlutterError.onError;
    _prevPlatform = PlatformDispatcher.instance.onError;
    FlutterError.onError = _onFlutterError;
    PlatformDispatcher.instance.onError = _onUncaughtError;
    return true;
  }

  /// 恢复安装前的 handler（测试用）。
  void dispose() {
    if (!_installed) return;
    _installed = false;
    FlutterError.onError = _prevFlutter;
    PlatformDispatcher.instance.onError = _prevPlatform;
  }

  void _onFlutterError(FlutterErrorDetails details) {
    FlutterError.presentError(details);
    log(details.exceptionAsString(), stack: details.stack?.toString());
  }

  bool _onUncaughtError(Object error, StackTrace stack) {
    log('$error', stack: stack.toString());
    return true;
  }

  /// 写入一条日志。磁盘写入失败不阻断。
  Future<void> log(String message, {String? stack}) async {
    final sb = StringBuffer()
      ..writeln('[${DateTime.now().toIso8601String()}]')
      ..writeln(message);
    if (stack != null && stack.isNotEmpty) sb.writeln(stack);
    sb.writeln('---');
    if (kDebugMode) debugPrint('[ErrorLogger] $message');
    try {
      final file = await _file();
      await file.writeAsString(
        sb.toString(),
        mode: FileMode.append,
        flush: true,
      );
      await _trimOld(file);
    } catch (_) {}
  }

  Future<File> _file() async {
    final root = overrideRootDir != null
        ? Directory('$overrideRootDir/$_dirName')
        : Directory(
            '${(await getApplicationDocumentsDirectory()).path}/$_dirName');
    await root.create(recursive: true);
    final now = DateTime.now();
    final name = 'error_${now.year.toString().padLeft(4, '0')}'
        '${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}.log';
    return File('${root.path}/$name');
  }

  Future<void> _trimOld(File file) async {
    final files = file.parent.listSync().whereType<File>().toList()
      ..sort((a, b) => a.path.compareTo(b.path));
    var extra = files.length - maxKeepFiles;
    for (final f in files) {
      if (extra <= 0) break;
      if (f.path == file.path) continue;
      try {
        f.delete();
      } catch (_) {}
      extra--;
    }
  }

  /// 读取全部日志（按文件名升序拼接），用于排查/导出。
  Future<String> readAll() async {
    final root = overrideRootDir != null
        ? Directory('$overrideRootDir/$_dirName')
        : Directory(
            '${(await getApplicationDocumentsDirectory()).path}/$_dirName');
    if (!await root.exists()) return '';
    final files = root.listSync().whereType<File>().toList()
      ..sort((a, b) => a.path.compareTo(b.path));
    final sb = StringBuffer();
    for (final f in files) {
      try {
        sb.writeln('===== ${f.uri.pathSegments.last} =====');
        sb.write(await f.readAsString());
      } catch (_) {}
    }
    return sb.toString();
  }
}
