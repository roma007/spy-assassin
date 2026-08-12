import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../pro/pro_store.dart';
import 'report_store.dart';

/// 一次已归档的检查记录（含现场照片文件路径）。
class ReportRecord {
  const ReportRecord({
    required this.id,
    required this.createdAt,
    required this.entries,
    required this.photoPaths,
    this.place = '',
  });

  final String id;
  final DateTime createdAt;
  final String place;
  final List<ReportEntry> entries;
  final List<String> photoPaths;

  int get riskCount =>
      entries.where((e) => e.risk != ReportRisk.safe).length;
}

/// 检测报告本地归档（数据不出设备）：
/// - 当前会话自动落盘到 `reports/active.json` + `reports/active/photo_*.jpg`
/// - 「完成本次检查」后归档为 `reports/<id>.json` + `reports/<id>/photo_*.jpg`
/// - 免费用户保留最近 [freeKeepCount] 份，Pro 不限。
class ReportArchive {
  ReportArchive._();

  static final ReportArchive instance = ReportArchive._();

  static const int freeKeepCount = 5;
  static const String _activeFile = 'active.json';

  /// 测试用：覆盖根目录，避免真实应用目录。
  @visibleForTesting
  static String? overrideRootDir;

  Timer? _debounce;

  Future<Directory> _root() async {
    if (overrideRootDir != null) return Directory(overrideRootDir!);
    final docs = await getApplicationDocumentsDirectory();
    return Directory('${docs.path}/reports');
  }

  Future<File> _activeJson() async =>
      File('${(await _root()).path}/$_activeFile');

  Future<Directory> _photosDir(String id) async =>
      Directory('${(await _root()).path}/$id');

  /// 启动时调用：订阅变化自动落盘 + 恢复未归档的当前会话。
  Future<void> init() async {
    ReportStore.instance.addListener(_onStoreChanged);
    await restoreCurrent();
  }

  void _onStoreChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      persistCurrent();
    });
  }

  /// 将当前会话（entries/photos/place）写入 active.json 与照片文件。
  Future<void> persistCurrent() async {
    final store = ReportStore.instance;
    try {
      if (store.entries.isEmpty) {
        final active = await _activeJson();
        if (await active.exists()) await active.delete();
        final dir = await _photosDir('active');
        if (await dir.exists()) await dir.delete(recursive: true);
        return;
      }
      final root = await _root();
      await root.create(recursive: true);
      final json = jsonEncode({
        'createdAt': DateTime.now().toIso8601String(),
        'place': store.place,
        'entries': [for (final e in store.entries) e.toJson()],
      });
      await (await _activeJson()).writeAsString(json, flush: true);
      final dir = await _photosDir('active');
      await dir.create(recursive: true);
      final existing = dir.listSync().whereType<File>().toList();
      for (var i = 0; i < store.photos.length; i++) {
        await File('${dir.path}/photo_$i.jpg')
            .writeAsBytes(store.photos[i], flush: true);
      }
      for (var i = store.photos.length; i < existing.length; i++) {
        await existing[i].delete();
      }
    } catch (_) {
      // 磁盘写入失败不阻断使用。
    }
  }

  /// 启动时恢复未归档的当前会话。
  Future<void> restoreCurrent() async {
    try {
      final file = await _activeJson();
      if (!await file.exists()) return;
      final map = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      final entries = [
        for (final e in map['entries'] as List<dynamic>? ?? const [])
          ReportEntry.fromJson(e as Map<String, dynamic>),
      ];
      final photos = <Uint8List>[];
      final dir = await _photosDir('active');
      if (await dir.exists()) {
        final files = dir.listSync().whereType<File>().toList()
          ..sort((a, b) => a.path.compareTo(b.path));
        for (final f in files) {
          photos.add(await f.readAsBytes());
        }
      }
      ReportStore.instance.replaceAll(entries, photos,
          place: map['place'] as String? ?? '');
    } catch (_) {}
  }

  /// 归档当前会话：active → `<id>`，随后按免费/Pro 清理超限历史。
  Future<void> seal() async {
    try {
      final store = ReportStore.instance;
      if (store.entries.isEmpty) return;
      await persistCurrent();
      final root = await _root();
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final active = await _activeJson();
      final activePhotos = await _photosDir('active');
      await active.rename('${root.path}/$id.json');
      if (await activePhotos.exists()) {
        await activePhotos.rename('${root.path}/$id');
      }
      store.clear();
      if (!ProStore.instance.isPro) {
        final all = await loadAll();
        var extra = all.length - freeKeepCount;
        for (var i = all.length - 1; i >= 0 && extra > 0; i--) {
          final rec = all[i];
          if (rec.id == id) continue;
          await _deleteRecord(rec.id);
          extra--;
        }
      }
    } catch (_) {}
  }

  /// 已归档报告列表（按时间倒序），photoPaths 为文件绝对路径。
  Future<List<ReportRecord>> loadAll() async {
    final result = <ReportRecord>[];
    try {
      final root = await _root();
      if (!await root.exists()) return result;
      final files = root.listSync().whereType<File>().toList();
      for (final f in files) {
        final name = f.uri.pathSegments.last;
        if (!name.endsWith('.json') || name == _activeFile) continue;
        final id = name.replaceAll('.json', '');
        try {
          final map =
              jsonDecode(await f.readAsString()) as Map<String, dynamic>;
          final entries = [
            for (final e in map['entries'] as List<dynamic>? ?? const [])
              ReportEntry.fromJson(e as Map<String, dynamic>),
          ];
          final photosDir = await _photosDir(id);
          final photoPaths = <String>[];
          if (await photosDir.exists()) {
            final ps = photosDir.listSync().whereType<File>().toList()
              ..sort((a, b) => a.path.compareTo(b.path));
            for (final p in ps) {
              photoPaths.add(p.path);
            }
          }
          result.add(ReportRecord(
            id: id,
            createdAt:
                DateTime.tryParse(map['createdAt'] as String? ?? '') ??
                    f.statSync().modified,
            place: map['place'] as String? ?? '',
            entries: entries,
            photoPaths: photoPaths,
          ));
        } catch (_) {}
      }
      result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (_) {}
    return result;
  }

  /// 把历史记录载入当前会话（删除其归档文件，转为 active 供继续编辑/导出）。
  Future<void> loadInto(ReportRecord record) async {
    final photos = <Uint8List>[];
    for (final p in record.photoPaths) {
      try {
        photos.add(await File(p).readAsBytes());
      } catch (_) {}
    }
    await _deleteRecord(record.id);
    ReportStore.instance.replaceAll(record.entries, photos,
        place: record.place);
    await persistCurrent();
  }

  Future<void> deleteRecord(String id) => _deleteRecord(id);

  Future<void> _deleteRecord(String id) async {
    try {
      final root = await _root();
      final file = File('${root.path}/$id.json');
      if (await file.exists()) await file.delete();
      final dir = await _photosDir(id);
      if (await dir.exists()) await dir.delete(recursive: true);
    } catch (_) {}
  }

  /// 清空当前会话与全部归档。
  Future<void> clearAll() async {
    ReportStore.instance.clear();
    try {
      final root = await _root();
      if (await root.exists()) await root.delete(recursive: true);
    } catch (_) {}
  }
}
