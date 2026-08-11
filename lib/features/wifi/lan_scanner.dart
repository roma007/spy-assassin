import 'dart:async';
import 'dart:io';

/// 局域网设备扫描：对当前网段做 TCP 端口探测，结合端口指纹与
/// MAC 厂商（OUI）识别可疑联网摄像头。
class LanScanner {
  LanScanner({this.timeout = const Duration(milliseconds: 350)});

  final Duration timeout;

  /// 端口指纹：端口 → 常见用途。
  static const Map<int, String> portInfo = {
    554: 'RTSP 视频流',
    8554: 'RTSP 备用',
    10554: 'RTSP 备用(海康等)',
    34567: '雄迈协议',
    37777: '大华协议',
    9000: '小米网关',
    80: 'HTTP',
    81: '摄像头 Web 备用',
    443: 'HTTPS',
    8000: '常见摄像头 Web',
    8080: 'HTTP 备用',
    8081: '摄像头 Web 备用',
    8888: 'TP-Link Web',
    8899: 'TP-Link/OM 备用',
  };

  /// 摄像头特征端口：命中即高风险，可提前结束探测。
  static const Set<int> highRiskPorts = {554, 8554, 10554, 34567, 37777, 9000};

  /// 探测顺序：先特征端口后通用端口。
  static const List<int> _probeOrder = [
    554, 8554, 10554, 34567, 37777, 9000, // 摄像头特征端口
    80, 81, 443, 8000, 8080, 8081, 8888, 8899, // 通用 Web 端口
  ];

  /// 扫描指定网段（如 192.168.1），返回存活且开放探测端口的主机。
  Future<List<LanDevice>> scan(String subnet) =>
      scanRange('$subnet.1', '$subnet.254');

  /// 扫描 [firstHost] ~ [lastHost]（含）的连续 IP 范围。
  Future<List<LanDevice>> scanRange(String firstHost, String lastHost) async {
    final first = _ipToInt(firstHost);
    final last = _ipToInt(lastHost);
    if (first == null || last == null || first > last) return const [];
    final arp = await ArpTable.read();
    final futures = <Future<LanDevice?>>[];
    for (var ip = first; ip <= last; ip++) {
      futures.add(_probeHost(_intToIp(ip), arp));
    }
    final results = await Future.wait(futures);
    return results.whereType<LanDevice>().toList();
  }

  static int? _ipToInt(String ip) {
    final parts = ip.split('.');
    if (parts.length != 4) return null;
    int? v;
    for (final p in parts) {
      final o = int.tryParse(p);
      if (o == null || o < 0 || o > 255) return null;
      v = (v ?? 0) << 8 | o;
    }
    return v;
  }

  static String _intToIp(int v) =>
      '${(v >> 24) & 255}.${(v >> 16) & 255}.${(v >> 8) & 255}.${v & 255}';

  Future<LanDevice?> _probeHost(String ip, Map<String, String> arp) async {
    final openPorts = <int>[];
    for (final port in _probeOrder) {
      if (await _isPortOpen(ip, port)) {
        openPorts.add(port);
        // 命中高特征端口后无需再探测其余通用端口
        if (highRiskPorts.contains(port)) break;
      }
    }
    if (openPorts.isEmpty) return null;
    final mac = arp[ip];
    final vendor = mac != null ? ouiLookupVendor(mac) : null;
    return LanDevice(ip: ip, openPorts: openPorts, mac: mac, vendor: vendor);
  }

  Future<bool> _isPortOpen(String ip, int port) async {
    try {
      final socket = await RawSocket.connect(ip, port, timeout: timeout);
      unawaited(socket.close());
      return true;
    } on SocketException {
      return false;
    } on TimeoutException {
      return false;
    }
  }

  /// 探测单台主机单端口是否可达（用于网关/网络连通性自检）。
  Future<bool> ping(String ip, int port) => _isPortOpen(ip, port);
}

enum DeviceRisk { low, medium, high }

class LanDevice {
  const LanDevice({
    required this.ip,
    required this.openPorts,
    this.mac,
    this.vendor,
    this.upnpInfo,
  });

  final String ip;
  final List<int> openPorts;

  /// MAC 地址（仅 Android 可读）。
  final String? mac;

  /// OUI 匹配到的厂商名。
  final String? vendor;

  /// 通过 UPnP/SSDP 发现到的设备描述（未探到开放探测端口时提供线索）。
  final String? upnpInfo;

  static const Set<int> _mediumPorts = {80, 8080, 8000, 8888};

  /// 风险分级：
  /// - high：命中摄像头特征端口，或厂商为摄像头制造商
  /// - medium：开放常见摄像头 Web 端口
  /// - low：其它
  DeviceRisk get risk {
    if (openPorts.any((p) => LanScanner.highRiskPorts.contains(p))) {
      return DeviceRisk.high;
    }
    final isCamVendor =
        vendor != null && OuiDb.cameraVendors.contains(vendor);
    if (isCamVendor && openPorts.isNotEmpty) return DeviceRisk.high;
    if (openPorts.any((p) => _mediumPorts.contains(p))) return DeviceRisk.medium;
    if (isCamVendor) return DeviceRisk.medium;
    return DeviceRisk.low;
  }

  bool get isHighRisk => risk == DeviceRisk.high;
  bool get isMediumRisk => risk == DeviceRisk.medium;

  String get riskLabel => switch (risk) {
        DeviceRisk.high => '高风险',
        DeviceRisk.medium => '可疑',
        DeviceRisk.low => '低风险',
      };

  String get portText => openPorts.join(', ');

  /// 风险依据说明。
  String get reason {
    final lines = <String>[
      for (final p in openPorts)
        '${LanScanner.portInfo[p] ?? '端口 $p'}(TCP $p)',
      if (vendor != null) 'MAC 厂商匹配：$vendor',
      if (upnpInfo != null) 'UPnP 发现：$upnpInfo',
    ];
    return lines.isEmpty ? '开放了探测端口' : lines.join('\n');
  }
}

/// 摄像头/网络设备常见 OUI 前缀 → 厂商（本地精简库，仅供线索参考）。
class OuiDb {
  OuiDb._();

  static const Map<String, String> vendors = {
    '44:19:B6': '海康威视',
    '10:29:8E': '海康威视',
    'C0:56:E3': '海康威视',
    '3C:E5:A6': '海康威视',
    'AC:CC:8E': '海康威视',
    'E8:75:33': '海康威视',
    '2C:90:0D': '海康威视',
    '4C:E2:50': '海康威视',
    '00:3E:24': '海康威视',
    '3C:E1:A1': '大华',
    '00:0A:45': '大华',
    '7C:DA:53': '大华',
    'B0:B4:5D': '大华',
    '48:C8:13': '大华',
    'EC:89:0E': '大华',
    '50:C7:BF': 'TP-Link',
    '64:66:B3': 'TP-Link',
    '70:4F:57': 'TP-Link',
    'D8:07:B6': 'TP-Link',
    '14:CF:92': 'TP-Link',
    '00:1D:0F': 'TP-Link',
    '18:A6:F7': 'TP-Link',
    '64:09:80': '小米',
    '78:11:DC': '小米',
    '8C:AA:B5': '小米',
    'C8:FD:19': '小米',
    'D0:EE:07': '小米',
    '00:1F:C4': '雄迈',
    '1C:7C:11': '雄迈',
    'E8:12:48': '中维世纪',
    '2C:2D:48': '中维世纪',
    '4C:65:A8': '乔安',
    '00:E0:FC': '华为',
    '48:46:FB': '华为',
    '3C:07:54': 'Apple',
    'A4:83:E7': 'Apple',
    'F0:18:98': 'Apple',
    'F4:8C:50': '荣耀',
    '78:E4:00': '联想',
    '50:6D:46': '诺基亚',
  };

  /// 摄像头制造商（匹配即显著提高风险）。
  static const Set<String> cameraVendors = {
    '海康威视',
    '大华',
    '雄迈',
    '中维世纪',
    '乔安',
  };
}

/// MAC 地址 → 厂商名（归一化后匹配 OUI 前三段）。
String? ouiLookupVendor(String mac) {
  final parts = mac.toUpperCase().replaceAll('-', ':').split(':');
  if (parts.length < 3) return null;
  final oui = '${parts[0]}:${parts[1]}:${parts[2]}';
  return OuiDb.vendors[oui];
}

/// 读取 /proc/net/arp 获得局域网 {IP: MAC} 映射（仅 Android 可读，
/// iOS 无该文件返回空表）。
class ArpTable {
  ArpTable._();

  static Future<Map<String, String>> read() async {
    final map = <String, String>{};
    try {
      final file = File('/proc/net/arp');
      if (!await file.exists()) return map;
      final lines = await file.readAsLines();
      for (final line in lines.skip(1)) {
        final parts = line.split(RegExp(r'\s+'));
        if (parts.length >= 4 &&
            parts[3] == '0x2' &&
            parts[1] != '00:00:00:00:00:00' &&
            parts[1].contains(':')) {
          map[parts[0]] = parts[1];
        }
      }
    } catch (_) {}
    return map;
  }
}

/// 从本机 IP 推导所在网段（支持 IPv4 私有网段）。
String? deriveSubnet(String localIp) {
  final parts = localIp.split('.');
  if (parts.length != 4) return null;
  return '${parts[0]}.${parts[1]}.${parts[2]}';
}
