import 'dart:async';
import 'dart:io';

/// 局域网设备扫描：对当前网段做 TCP 端口探测，结合端口指纹、RTSP/HTTP
/// 指纹与 MAC 厂商（OUI）识别可疑联网摄像头。
class LanScanner {
  LanScanner({
    this.timeout = const Duration(milliseconds: 350),
    this.retryTimeout = const Duration(milliseconds: 1800),
    this.concurrency = 64,
  });

  final Duration timeout;

  /// 长超时：WiFi 省电（休眠）设备的 SYN 由 AP 缓存、等它醒来才投递，
  /// 快速探测阶段用该超时覆盖常见唤醒周期，避免休眠摄像头漏报。
  final Duration retryTimeout;

  /// 同时探测的主机数上限。一次性对整网段并发连接会造成 WiFi 连接风暴，
  /// 让休眠/忙碌设备在超时内不应答而漏报，因此按批限流。
  final int concurrency;

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

  /// 存活发现的快速探测端口：摄像头最常暴露的端口，先于全端口深探。
  static const List<int> _quickProbeOrder = [554, 80];

  /// 快速探测阶段使用长超时的端口（主要是 554，覆盖休眠唤醒周期）。
  static const Set<int> _quickSlowPorts = {554};

  /// 扫描指定网段（如 192.168.1），返回存活且开放探测端口的主机。
  Future<List<LanDevice>> scan(String subnet) =>
      scanRange('$subnet.1', '$subnet.254');

  /// 扫描 [firstHost] ~ [lastHost]（含）的连续 IP 范围。
  ///
  /// 两阶段降低漏报：先对全段快速探测 [554, 80] 找存活主机（限并发避免连接
  /// 风暴；554 用长超时覆盖 WiFi 省电休眠设备的唤醒周期），再只对存活主机做
  /// 全端口深探。Android 上出现在 ARP 表的主机也会强制深探。
  Future<List<LanDevice>> scanRange(String firstHost, String lastHost) async {
    final first = _ipToInt(firstHost);
    final last = _ipToInt(lastHost);
    if (first == null || last == null || first > last) return const [];
    final arp = await ArpTable.read();
    final hosts = [for (var ip = first; ip <= last; ip++) _intToIp(ip)];

    // 阶段 A：快速探测找存活主机（554 长超时，可唤醒省电休眠的设备）。
    final live = <String>{
      for (final d in await _probeAll(hosts, _quickProbeOrder, arp,
          slowPorts: _quickSlowPorts))
        d.ip,
    };

    // Android 上 ARP 表里出现过的主机即使快速探测无响应也强制深探一次。
    live.addAll(arp.keys.where((ip) => hosts.contains(ip)));

    // 阶段 B：对存活主机做全端口深探（含指纹）。
    return _probeAll(live.toList(), _probeOrder, arp);
  }

  /// 限并发地对一批主机做端口探测，返回开放端口的主机。
  /// 快速发现阶段不抓指纹（结果只用其 IP），只有最终深探才做指纹。
  /// [slowPorts] 中的端口使用 [retryTimeout]（长超时）。
  Future<List<LanDevice>> _probeAll(
    List<String> ips,
    List<int> ports,
    Map<String, String> arp, {
    bool fingerprint = true,
    Set<int> slowPorts = const {},
  }) async {
    final results = <LanDevice>[];
    for (var i = 0; i < ips.length; i += concurrency) {
      final end = i + concurrency < ips.length ? i + concurrency : ips.length;
      final futures = <Future<LanDevice?>>[];
      for (final ip in ips.sublist(i, end)) {
        futures.add(_probeHost(ip, ports, arp,
            fingerprint: fingerprint, slowPorts: slowPorts));
      }
      results.addAll((await Future.wait(futures)).whereType<LanDevice>());
    }
    return results;
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

  Future<LanDevice?> _probeHost(
    String ip,
    List<int> ports,
    Map<String, String> arp, {
    bool fingerprint = true,
    Set<int> slowPorts = const {},
  }) async {
    final openPorts = <int>[];
    for (final port in ports) {
      if (await _isPortOpen(ip, port,
          timeout: slowPorts.contains(port) ? retryTimeout : timeout)) {
        openPorts.add(port);
        // 命中高特征端口后无需再探测其余通用端口
        if (highRiskPorts.contains(port)) break;
      }
    }
    if (openPorts.isEmpty) return null;
    final mac = arp[ip];
    final vendor = mac != null ? ouiLookupVendor(mac) : null;
    final (rtsp, httpServer, httpTitle) = fingerprint
        ? await _fingerprint(ip, openPorts)
        : (null, null, null);
    return LanDevice(
      ip: ip,
      openPorts: openPorts,
      mac: mac,
      vendor: vendor,
      rtspServer: rtsp,
      httpServer: httpServer,
      httpTitle: httpTitle,
    );
  }

  Future<bool> _isPortOpen(String ip, int port,
      {Duration? timeout}) async {
    try {
      final socket = await RawSocket.connect(ip, port,
          timeout: timeout ?? this.timeout);
      unawaited(socket.close());
      return true;
    } on SocketException {
      return false;
    } on TimeoutException {
      return false;
    }
  }

  /// 对开放端口的主机做 RTSP/HTTP 指纹探测，弥补 iOS 无法读取 MAC 的短板。
  Future<(String?, String?, String?)> _fingerprint(
    String ip,
    List<int> openPorts,
  ) async {
    String? rtsp;
    String? httpServer;
    String? httpTitle;
    if (openPorts.contains(554)) {
      rtsp = await _probeRtsp(ip);
    }
    final webPort = _webPortOf(openPorts);
    if (webPort != null) {
      final http = await _probeHttp(ip, webPort);
      httpServer = http.$1;
      httpTitle = http.$2;
    }
    return (rtsp, httpServer, httpTitle);
  }

  static const List<int> _httpProbePorts = [80, 8080, 8000, 81, 8081, 8888, 8899];

  static int? _webPortOf(List<int> openPorts) {
    for (final p in _httpProbePorts) {
      if (openPorts.contains(p)) return p;
    }
    return null;
  }

  /// 发一个 RTSP OPTIONS 请求，返回 Server 头（失败返回 null）。
  Future<String?> _probeRtsp(String ip) async {
    Socket? socket;
    try {
      socket = await Socket.connect(ip, 554, timeout: timeout);
      socket.write('OPTIONS rtsp://$ip:554/ RTSP/1.0\r\nCSeq: 1\r\n\r\n');
      await socket.flush();
      final text =
          await _collectResponse(socket, const Duration(milliseconds: 800));
      if (!text.toUpperCase().startsWith('RTSP/1.0')) return null;
      final server = _headerOf(text, 'Server');
      if (server != null && server.isNotEmpty) return server;
      return text.split('\r\n').first;
    } catch (_) {
      return null;
    } finally {
      socket?.destroy();
    }
  }

  /// 抓取设备的 HTTP 首页，返回 (Server 头, 页面 <title>)。
  Future<(String?, String?)> _probeHttp(String ip, int port) async {
    Socket? socket;
    try {
      socket = await Socket.connect(ip, port, timeout: timeout);
      socket.write('GET / HTTP/1.1\r\nHost: $ip\r\nConnection: close\r\n\r\n');
      await socket.flush();
      final text =
          await _collectResponse(socket, const Duration(milliseconds: 1000));
      final server = _headerOf(text, 'Server');
      final m = RegExp(r'<title[^>]*>([\s\S]*?)</title>',
              caseSensitive: false)
          .firstMatch(text);
      final title = m?.group(1)?.trim();
      return (server, title);
    } catch (_) {
      return (null, null);
    } finally {
      socket?.destroy();
    }
  }

  /// 读取响应直到收到 \r\n\r\n 或超过 [limit]（最多收集 8KB，防止卡住）。
  Future<String> _collectResponse(Socket socket, Duration limit) async {
    final buffer = StringBuffer();
    try {
      await socket.timeout(limit).forEach((chunk) {
        buffer.write(String.fromCharCodes(chunk));
        if (buffer.length > 8192 || buffer.toString().contains('\r\n\r\n')) {
          socket.destroy();
        }
      });
    } catch (_) {
      // 超时/连接被断开等一律视为未取到响应，不阻塞扫描。
    }
    return buffer.toString();
  }

  static String? _headerOf(String text, String name) {
    final prefix = '${name.toLowerCase()}:';
    for (final line in text.split('\r\n')) {
      if (line.toLowerCase().startsWith(prefix)) {
        return line.substring(line.indexOf(':') + 1).trim();
      }
    }
    return null;
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
    this.hostname,
    this.rtspServer,
    this.httpServer,
    this.httpTitle,
    this.stale = false,
    this.lastSeenAt,
  });

  final String ip;
  final List<int> openPorts;

  /// MAC 地址（仅 Android 可读）。
  final String? mac;

  /// OUI 匹配到的厂商名。
  final String? vendor;

  /// 通过 UPnP/SSDP 发现到的设备描述（未探到开放探测端口时提供线索）。
  final String? upnpInfo;

  /// mDNS 反向解析出的主机名（如 ipcamera.local 设备的名称）。
  final String? hostname;

  /// RTSP OPTIONS 响应中的 Server 头（确认设备是 RTSP 摄像头）。
  final String? rtspServer;

  /// HTTP 首页响应中的 Server 头。
  final String? httpServer;

  /// HTTP 首页 <title>。
  final String? httpTitle;

  /// 本次扫描未响应、由历史记录回填的休眠/离线设备。
  final bool stale;

  /// 最后在线时间（仅 [stale] 设备由历史记录携带）。
  final DateTime? lastSeenAt;

  /// 摄像头专属 Web 端口（区别于路由器/服务器等也常开的 80/443/8080）。
  static const Set<int> _cameraWebPorts = {81, 8000, 8081, 8888, 8899};

  /// 风险分级：
  /// - high：命中摄像头特征端口，RTSP 指纹确认，或厂商为摄像头制造商
  /// - medium：开放摄像头专属 Web 端口，或 HTTP 指纹疑似摄像头
  /// - low：仅开放通用 Web 端口（80/443/8080）等
  DeviceRisk get risk {
    if (openPorts.any((p) => LanScanner.highRiskPorts.contains(p))) {
      return DeviceRisk.high;
    }
    final isCamVendor =
        vendor != null && OuiDb.cameraVendors.contains(vendor);
    if (isCamVendor && openPorts.isNotEmpty) return DeviceRisk.high;
    if (rtspServer != null) return DeviceRisk.high;
    if (isCamVendor) return DeviceRisk.medium;
    if (FingerprintDb.looksLikeCamera(httpServer) ||
        FingerprintDb.looksLikeCamera(httpTitle)) {
      return DeviceRisk.medium;
    }
    if (openPorts.any((p) => _cameraWebPorts.contains(p))) {
      return DeviceRisk.medium;
    }
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

  /// 返回携带主机名的新设备（字段不可变，用于扫描后补全 mDNS 名称）。
  LanDevice withHostname(String? name) => LanDevice(
        ip: ip,
        openPorts: openPorts,
        mac: mac,
        vendor: vendor,
        upnpInfo: upnpInfo,
        hostname: name ?? hostname,
        rtspServer: rtspServer,
        httpServer: httpServer,
        httpTitle: httpTitle,
        stale: stale,
        lastSeenAt: lastSeenAt,
      );

  /// 风险依据说明。
  String get reason {
    final lines = <String>[
      if (stale) '本次未响应（可能休眠），来自历史记录',
      for (final p in openPorts)
        '${LanScanner.portInfo[p] ?? '端口 $p'}(TCP $p)',
      if (vendor != null) 'MAC 厂商匹配：$vendor',
      if (rtspServer != null) 'RTSP 指纹：$rtspServer',
      if (httpServer != null || httpTitle != null)
        'HTTP 指纹：${[httpServer, httpTitle].whereType<String>().join(' / ')}',
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

/// 从 RTSP/HTTP 指纹文本中识别疑似摄像头的关键词（供线索参考）。
class FingerprintDb {
  FingerprintDb._();

  static const List<String> cameraKeywords = [
    'tapo',
    'hik',
    'dahua',
    'xiongmai',
    'zmeye',
    'reolink',
    'amcrest',
    'geovision',
    'swann',
    'axis',
    'ipcam',
    'ipc',
    'ipc-',
    'cctv',
    'rtsp',
    'dvr',
    'nvr',
    'p2p',
    'camera',
    '摄像头',
    '监控',
  ];

  static bool looksLikeCamera(String? value) {
    if (value == null || value.isEmpty) return false;
    final lower = value.toLowerCase();
    return cameraKeywords.any(lower.contains);
  }
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
