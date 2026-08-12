import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'lan_scanner.dart';

/// 单台设备的持久化历史记录：用于在设备休眠/未响应时仍能列出
/// 曾经确认过的摄像头。
class DeviceHistoryRecord {
  const DeviceHistoryRecord({
    required this.ip,
    this.mac,
    this.vendor,
    this.hostname,
    this.openPorts = const [],
    this.rtspServer,
    this.httpServer,
    this.httpTitle,
    this.firstSeenAt,
    this.lastSeenAt,
    this.everCamera = false,
  });

  final String ip;
  final String? mac;
  final String? vendor;
  final String? hostname;
  final List<int> openPorts;
  final String? rtspServer;
  final String? httpServer;
  final String? httpTitle;
  final DateTime? firstSeenAt;
  final DateTime? lastSeenAt;

  /// 是否曾判定为摄像头（高风险/可疑/摄像头厂商），是休眠回填的依据。
  final bool everCamera;

  factory DeviceHistoryRecord.fromJson(String ip, Map<String, dynamic> json) {
    DateTime? time(String? key) =>
        json[key] == null ? null : DateTime.tryParse(json[key] as String);
    return DeviceHistoryRecord(
      ip: ip,
      mac: json['mac'] as String?,
      vendor: json['vendor'] as String?,
      hostname: json['hostname'] as String?,
      openPorts: (json['ports'] as List<dynamic>? ?? const [])
          .whereType<int>()
          .toList(),
      rtspServer: json['rtsp'] as String?,
      httpServer: json['httpServer'] as String?,
      httpTitle: json['httpTitle'] as String?,
      firstSeenAt: time('firstSeen'),
      lastSeenAt: time('lastSeen'),
      everCamera: json['camera'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'mac': mac,
        'vendor': vendor,
        'hostname': hostname,
        'ports': openPorts,
        'rtsp': rtspServer,
        'httpServer': httpServer,
        'httpTitle': httpTitle,
        'firstSeen': firstSeenAt?.toIso8601String(),
        'lastSeen': lastSeenAt?.toIso8601String(),
        'camera': everCamera,
      };
}

/// 设备历史持久化（SharedPreferences + JSON）。
class DeviceHistoryStore {
  DeviceHistoryStore._();

  static const _key = 'device_history';

  static Future<Map<String, DeviceHistoryRecord>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return {};
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final result = <String, DeviceHistoryRecord>{};
      for (final e in map.entries) {
        if (e.value is Map<String, dynamic>) {
          result[e.key] =
              DeviceHistoryRecord.fromJson(e.key, e.value as Map<String, dynamic>);
        }
      }
      return result;
    } catch (_) {
      return {};
    }
  }

  /// 合并本次扫描结果并保存：在线设备更新记录（含 lastSeen），其余历史保留。
  static Future<void> save(List<LanDevice> live) async {
    final now = DateTime.now();
    final history = await load();
    for (final d in live) {
      if (d.stale) continue;
      final prev = history[d.ip];
      history[d.ip] = DeviceHistoryRecord(
        ip: d.ip,
        mac: d.mac ?? prev?.mac,
        vendor: d.vendor ?? prev?.vendor,
        hostname: d.hostname ?? prev?.hostname,
        openPorts: d.openPorts,
        rtspServer: d.rtspServer ?? prev?.rtspServer,
        httpServer: d.httpServer ?? prev?.httpServer,
        httpTitle: d.httpTitle ?? prev?.httpTitle,
        firstSeenAt: prev?.firstSeenAt ?? now,
        lastSeenAt: now,
        everCamera: prev?.everCamera ?? (d.isHighRisk || d.isMediumRisk),
      );
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(history.map((ip, r) => MapEntry(ip, r.toJson()))),
    );
  }

  /// 从历史中回填本次未响应但曾经确认是摄像头的设备（标 stale）。
  static List<LanDevice> staleFromHistory(
    Map<String, DeviceHistoryRecord> history,
    Set<String> liveIps,
  ) {
    final result = <LanDevice>[];
    for (final r in history.values) {
      if (!r.everCamera) continue;
      if (liveIps.contains(r.ip)) continue;
      result.add(LanDevice(
        ip: r.ip,
        openPorts: r.openPorts,
        mac: r.mac,
        vendor: r.vendor,
        hostname: r.hostname,
        rtspServer: r.rtspServer,
        httpServer: r.httpServer,
        httpTitle: r.httpTitle,
        stale: true,
        lastSeenAt: r.lastSeenAt,
      ));
    }
    result.sort((a, b) => a.ip.compareTo(b.ip));
    return result;
  }
}
