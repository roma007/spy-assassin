import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// SSDP (UPnP) 设备发现：向组播地址发送 M-SEARCH，收集局域网内
/// 支持 UPnP 的设备（摄像头/DVR/路由器/电视等）的 IP 与描述信息。
///
/// 额外作用：向局域网发送组播会触发 iOS 的「本地网络」授权弹窗，
/// 使权限状态从未确定变为明确，避免 TCP 连接被系统静默丢弃。
class SsdpDevice {
  const SsdpDevice({
    required this.ip,
    this.server,
    this.location,
    this.serviceType,
  });

  final String ip;

  /// SERVER 头，通常含设备类型描述。
  final String? server;

  /// LOCATION 头，指向设备描述文档（XML）。
  final String? location;

  /// ST/USN 头。
  final String? serviceType;
}

class SsdpDiscoverer {
  static final InternetAddress _group = InternetAddress('239.255.255.250');
  static const _port = 1900;

  /// 发现局域网内的 UPnP 设备，[timeout] 秒内收集响应。
  Future<List<SsdpDevice>> discover({
    Duration timeout = const Duration(seconds: 3),
  }) async {
    final devices = <SsdpDevice>[];
    try {
      final socket = await RawDatagramSocket.bind(
        InternetAddress.anyIPv4,
        0,
        reuseAddress: true,
      );
      socket.multicastHops = 2;
      socket.multicastLoopback = true;

      final msearch = [
        'M-SEARCH * HTTP/1.1',
        'HOST: 239.255.255.250:1900',
        'MAN: "ssdp:discover"',
        'MX: 2',
        'ST: ssdp:all',
        '',
        '',
      ].join('\r\n');
      socket.send(utf8.encode(msearch), _group, _port);

      final completer = Completer<void>();
      socket.listen((event) {
        if (event != RawSocketEvent.read) return;
        final dg = socket.receive();
        if (dg == null) return;
        final text = utf8.decode(dg.data, allowMalformed: true);
        if (!text.startsWith('HTTP/1.1')) return;
        final ip = dg.address.address;
        if (devices.every((d) => d.ip != ip)) {
          devices.add(SsdpDevice(
            ip: ip,
            server: _header(text, 'SERVER'),
            location: _header(text, 'LOCATION'),
            serviceType: _header(text, 'ST') ?? _header(text, 'USN'),
          ));
        }
      });
      await Future.delayed(timeout);
      socket.close();
      if (!completer.isCompleted) completer.complete();
      await completer.future;
    } catch (_) {}
    return devices;
  }

  static String? _header(String text, String name) {
    final prefix = '${name.toLowerCase()}:';
    for (final line in text.split('\r\n')) {
      if (line.toLowerCase().startsWith(prefix)) {
        return line.substring(line.indexOf(':') + 1).trim();
      }
    }
    return null;
  }
}
