import 'package:multicast_dns/multicast_dns.dart';

/// 反向 mDNS 名称：192.168.31.132 → 132.31.168.192.in-addr.arpa。
String mdnsReverseName(String ip) {
  final parts = ip.split('.');
  if (parts.length != 4) return '$ip.in-addr.arpa';
  return '${parts.reversed.join('.')}.in-addr.arpa';
}

/// 用 mDNS（组播 5353）反向解析设备主机名。部分摄像头会注册 `.local`
/// 名称，解析成功后列表页可直接显示「设备名称」，显著降低未知设备困惑。
/// 非 mDNS 设备（如多数 Windows）不响应，属正常情况，调用方容错即可。
class MdnsResolver {
  MdnsResolver({
    this.timeout = const Duration(milliseconds: 1500),
    this.concurrency = 8,
  });

  final Duration timeout;
  final int concurrency;

  /// 批量反向解析，返回 IP → 主机名（去掉末尾 `.local`）。失败/无响应则跳过。
  Future<Map<String, String>> resolveNames(List<String> ips) async {
    final result = <String, String>{};
    if (ips.isEmpty) return result;
    final client = MDnsClient();
    try {
      await client.start();
      for (final ip in ips) {
        final name = mdnsReverseName(ip);
        try {
          final query = ResourceRecordQuery.serverPointer(name);
          await for (final record in client.lookup<PtrResourceRecord>(
              query,
              timeout: timeout)) {
            final raw = record.domainName;
            final host = raw.endsWith('.local.')
                ? raw.substring(0, raw.length - 7)
                : raw.replaceAll(RegExp(r'\.local$'), '');
            if (host.isNotEmpty) {
              result[ip] = host;
              break;
            }
          }
        } catch (_) {
          // 单台解析失败不影响其余设备
        }
      }
    } catch (_) {
      // mDNS 不可用（如某些网络环境）时整体跳过
    } finally {
      try {
        client.stop();
      } catch (_) {}
    }
    return result;
  }
}