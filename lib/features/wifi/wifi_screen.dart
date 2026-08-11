import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:privacy_camera/l10n/app_localizations.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/permissions/permission_helper.dart';
import '../../core/pro/upgrade_dialog.dart';
import '../../core/report/report_store.dart';
import '../../core/stats/stat_store.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_widgets.dart';
import 'lan_scanner.dart';
import 'ssdp_discoverer.dart';

/// WiFi 扫描页：扫描局域网设备，识别可疑的联网摄像头。
class WifiScreen extends StatefulWidget {
  const WifiScreen({super.key});

  @override
  State<WifiScreen> createState() => _WifiScreenState();
}

class _WifiScreenState extends State<WifiScreen> {
  static const _knownKey = 'known_device_ips';

  bool _scanning = false;
  bool _permissionDenied = false;
  String? _ssid;
  String? _localIp;
  String? _gateway;
  String? _mask;
  String? _error;
  List<LanDevice> _devices = const [];
  final Set<String> _knownIps = {};

  @override
  void initState() {
    super.initState();
    _loadKnownDevices();
    _loadNetworkInfo();
  }

  Future<void> _loadKnownDevices() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_knownKey) ?? const [];
    if (mounted) {
      setState(() {
        _knownIps
          ..clear()
          ..addAll(saved);
      });
    }
  }

  Future<void> _saveKnownDevices() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_knownKey, _knownIps.toList());
  }

  void _toggleKnown(LanDevice device) {
    setState(() {
      if (!_knownIps.remove(device.ip)) {
        _knownIps.add(device.ip);
      }
    });
    _saveKnownDevices();
  }

  Future<void> _loadNetworkInfo() async {
    if (mounted) {
      setState(() {
        _permissionDenied = false;
        _error = null;
      });
    }
    // 仅 Android 需要定位权限才能读取 WiFi 信息；iOS 由系统自动弹窗询问本地网络。
    if (Platform.isAndroid) {
      final granted = await PermissionHelper.requestLocation();
      if (!granted) {
        if (mounted) setState(() => _permissionDenied = true);
        return;
      }
    }
    await PermissionHelper.requestLocalNetwork();
    final info = NetworkInfo();
    String? ssid;
    String? ip;
    String? gateway;
    String? mask;
    try {
      ssid = await info.getWifiName();
    } catch (_) {}
    try {
      ip = await info.getWifiIP();
    } catch (_) {}
    try {
      gateway = await info.getWifiGatewayIP();
    } catch (_) {}
    try {
      mask = await info.getWifiSubmask();
    } catch (_) {}
    if (mounted) {
      setState(() {
        _ssid = ssid;
        _localIp = ip;
        _gateway = gateway;
        _mask = mask;
      });
    }
  }

  /// 由 IP + 掩码计算扫描的起止主机 IP（网关等首尾地址排除）。
  (String, String)? _hostRange() {
    final ip = _localIp;
    final mask = _mask;
    if (ip == null) return null;
    int? octet(String s, int i) => int.tryParse(s);

    int? toInt(String s) {
      final p = s.split('.');
      if (p.length != 4) return null;
      var v = 0;
      for (var i = 0; i < 4; i++) {
        final o = octet(p[i], i);
        if (o == null || o < 0 || o > 255) return null;
        v = v << 8 | o;
      }
      return v;
    }

    String toStr(int v) =>
        '${(v >> 24) & 255}.${(v >> 16) & 255}.${(v >> 8) & 255}.${v & 255}';
    final a = toInt(ip);
    final m = toInt(mask ?? '') ?? 0xFFFFFF00;
    if (a == null) return null;
    final network = a & m;
    final broadcast = network | (~m & 0xFFFFFFFF);
    final first = network + 1;
    final last = broadcast - 1;
    if (first >= last) return null;
    return (toStr(first), toStr(last));
  }

  Future<void> _scan() async {
    if (!await ensureAccess(context)) return;
    StatStore.instance.recordWifi();
    final range = _hostRange();
    if (range == null) {
      setState(() =>
          _error = AppLocalizations.of(context)!.wifiNeedInfo);
      return;
    }
    setState(() {
      _scanning = true;
      _devices = const [];
      _error = null;
    });
    final scanner = LanScanner();
    // SSDP 与 TCP 端口扫描并行；组播发送还能触发 iOS「本地网络」授权弹窗
    final ssdpFuture = SsdpDiscoverer().discover();
    final tcpDevices = await scanner.scanRange(range.$1, range.$2);
    final ssdpDevices = await ssdpFuture;
    final byIp = <String, LanDevice>{for (final d in tcpDevices) d.ip: d};
    // 仅被 SSDP 发现、但未探到开放端口的设备也列入结果，作为线索
    final tcpIps = byIp.keys.toSet();
    for (final s in ssdpDevices) {
      if (tcpIps.contains(s.ip)) continue;
      byIp[s.ip] = LanDevice(
        ip: s.ip,
        openPorts: const [],
        upnpInfo: s.server ?? s.location ?? 'UPnP 设备',
      );
    }
    final devices = byIp.values.toList();
    if (mounted) {
      setState(() {
        _scanning = false;
        _devices = devices;
      });
      _recordScanResult(devices);
      if (devices.isNotEmpty) {
        HapticFeedback.heavyImpact();
      } else {
        await _showEmptyHint(scanner, range.$1, range.$2);
      }
    }
  }

  /// 扫描完成时记录本次结论到检测报告。
  void _recordScanResult(List<LanDevice> devices) {
    final l10n = AppLocalizations.of(context)!;
    final suspicious =
        devices.where((d) => !_knownIps.contains(d.ip)).toList();
    final high = suspicious.where((d) => d.isHighRisk).toList();
    final medium = suspicious.where((d) => d.isMediumRisk).toList();

    final risk = high.isNotEmpty
        ? ReportRisk.high
        : medium.isNotEmpty
            ? ReportRisk.low
            : ReportRisk.safe;

    final detail = <String>[
      if (high.isNotEmpty) l10n.wifiHighCount(high.length),
      if (medium.isNotEmpty) l10n.wifiMediumCount(medium.length),
      if (devices.isEmpty) l10n.wifiNoOpenDevices,
      for (final d in high.take(5)) '${d.ip}${d.vendor != null ? '(${d.vendor})' : ''}: ${d.reason.split('\n').first}',
      for (final d in medium.take(3)) '${d.ip}${d.vendor != null ? '(${d.vendor})' : ''}',
    ];

    ReportStore.instance.add(ReportEntry(
      featureKey: 'wifi',
      time: DateTime.now(),
      risk: risk,
      wifiName: _ssid,
      summary: l10n.wifiSummary(
          _ssid ?? l10n.wifiUnknown, devices.length, detail.join('；')),
    ));
  }

  /// 扫描为空时的引导与网络自检。
  Future<void> _showEmptyHint(
      LanScanner scanner, String firstHost, String lastHost) async {
    final l10n = AppLocalizations.of(context)!;
    var gwOk = false;
    final gateways = <String>{?_gateway, firstHost};
    String? gwHit;
    for (final gw in gateways) {
      for (final port in const [80, 443, 8080]) {
        if (await scanner.ping(gw, port)) {
          gwOk = true;
          gwHit = '$gw:$port';
          break;
        }
      }
      if (gwOk) break;
    }
    // 公网可达性对照：区分「局域网被隔离」与「整体无网络」
    final internetOk = await scanner.ping('1.1.1.1', 80);

    String verdict;
    if (gwOk) {
      verdict = l10n.wifiVerdictGw('$gwHit');
    } else if (internetOk) {
      verdict = l10n.wifiVerdictInternet;
    } else {
      verdict = l10n.wifiVerdictNone;
    }
    if (mounted) {
      setState(() => _error = verdict);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_permissionDenied) return _buildPermissionDenied();
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      children: [
        _buildNetworkCard(),
        _buildAction(),
        if (_error != null && !_scanning)
          SectionCard(
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded,
                    color: AppColors.textSecondary, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(_error!,
                      style: const TextStyle(
                          fontSize: 12.5, color: AppColors.textSecondary)),
                ),
              ],
            ),
          ),
        if (_devices.isNotEmpty) _buildResults(),
        const SizedBox(height: 8),
        SectionCard(
          child: Text(
            l10n.wifiDisclaimer,
            style: const TextStyle(
                fontSize: 11.5, color: AppColors.textSecondary, height: 1.5),
          ),
        ),
      ],
    );
  }

  Widget _buildNetworkCard() {
    final l10n = AppLocalizations.of(context)!;
    return SectionCard(
      child: Row(
        children: [
          const Icon(Icons.wifi_rounded, color: AppColors.primary, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _ssid ?? l10n.wifiNotConnected,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  _localIp ?? l10n.wifiGettingInfo,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
                if (_localIp != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      l10n.wifiGatewayMask(
                          _gateway ?? l10n.wifiUnknown, _mask ?? '255.255.255.0'),
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAction() {
    final l10n = AppLocalizations.of(context)!;
    return SectionCard(
      child: FilledButton.icon(
        onPressed: _scanning ? null : _scan,
        icon: _scanning
            ? const SizedBox(
                width: 18,
                height: 18,
                child:
                    CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : const Icon(Icons.radar_rounded),
        label: Text(_scanning ? l10n.wifiScanning : l10n.wifiStartScan),
      ),
    );
  }

  Widget _buildResults() {
    final l10n = AppLocalizations.of(context)!;
    // 疑似设备按风险降序排列，已知设备（“我的设备”）放最后
    final suspicious = _devices.where((d) => !_knownIps.contains(d.ip)).toList()
      ..sort((a, b) {
        final byRisk = b.risk.index.compareTo(a.risk.index);
        return byRisk != 0 ? byRisk : a.ip.compareTo(b.ip);
      });
    final known =
        _devices.where((d) => _knownIps.contains(d.ip)).toList()
          ..sort((a, b) => a.ip.compareTo(b.ip));
    final high = suspicious.where((d) => d.isHighRisk).length;
    final medium = suspicious.where((d) => d.isMediumRisk).length;

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(l10n.wifiResults,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              const Spacer(),
              Text(l10n.wifiRiskCounts(high, medium),
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 12),
          for (final d in suspicious)
            _DeviceTile(
              device: d,
              isKnown: false,
              onTap: () => _showDetail(d),
              onLongPress: () => _toggleKnown(d),
            ),
          if (known.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 8),
              child: Text(l10n.wifiMyDevices,
                  style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600)),
            ),
            for (final d in known)
              _DeviceTile(
                device: d,
                isKnown: true,
                onTap: () => _showDetail(d),
                onLongPress: () => _toggleKnown(d),
              ),
          ],
        ],
      ),
    );
  }

  void _showDetail(LanDevice device) {
    final isKnown = _knownIps.contains(device.ip);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(device.ip,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  RiskChip(
                    label: _WifiRiskLabels.of(l10n, device),
                    color: device.isHighRisk
                        ? AppColors.riskHigh
                        : device.isMediumRisk
                            ? AppColors.riskLow
                            : AppColors.safe,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(l10n.wifiDetailReason(device.reason),
                  style: const TextStyle(
                      fontSize: 12.5, color: AppColors.textSecondary, height: 1.5)),
              const SizedBox(height: 14),
              _DetailRow(label: l10n.wifiDetailIp, value: device.ip),
              if (device.mac != null) _DetailRow(label: l10n.wifiDetailMac, value: device.mac!),
              if (device.vendor != null)
                _DetailRow(label: l10n.wifiDetailVendor, value: device.vendor!),
              _DetailRow(
                label: l10n.wifiDetailPorts,
                value: device.openPorts.isEmpty
                    ? l10n.wifiNone
                    : device.openPorts
                        .map((p) => '$p(${LanScanner.portInfo[p] ?? l10n.wifiPortUnknown})')
                        .join('、'),
              ),
              if (device.upnpInfo != null)
                _DetailRow(label: l10n.wifiDetailUpnp, value: device.upnpInfo!),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: isKnown
                    ? OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _toggleKnown(device);
                        },
                        icon: const Icon(Icons.check_circle_rounded),
                        label: Text(l10n.wifiMarkedCancel),
                      )
                    : FilledButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _toggleKnown(device);
                        },
                        icon: const Icon(Icons.check_rounded),
                        label: Text(l10n.wifiMarkAsMine),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPermissionDenied() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off_rounded,
                size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(l10n.wifiPermTitle,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(
              l10n.wifiPermDesc,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () async {
                await PermissionHelper.openSettings();
                _loadNetworkInfo();
              },
              child: Text(l10n.goToSettings),
            ),
          ],
        ),
      ),
    );
  }
}

class _WifiRiskLabels {
  static String of(AppLocalizations l10n, LanDevice device) => switch (device.risk) {
        DeviceRisk.high => l10n.bleRiskHigh,
        DeviceRisk.medium => l10n.bleRiskMedium,
        DeviceRisk.low => l10n.bleRiskLow,
      };
}

class _DeviceTile extends StatelessWidget {
  const _DeviceTile({
    required this.device,
    required this.isKnown,
    required this.onTap,
    required this.onLongPress,
  });

  final LanDevice device;
  final bool isKnown;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final risk = isKnown
        ? RiskChip(label: l10n.wifiMyDeviceChip, color: AppColors.safe)
        : RiskChip(
            label: _WifiRiskLabels.of(l10n, device),
            color: device.isHighRisk
                ? AppColors.riskHigh
                : device.isMediumRisk
                    ? AppColors.riskLow
                    : AppColors.safe,
          );
    final subtitle = [
      if (device.vendor != null) device.vendor!,
      if (device.mac != null) device.mac!,
      if (device.openPorts.isNotEmpty) l10n.wifiPorts(device.portText),
      if (device.openPorts.isEmpty && device.upnpInfo != null) device.upnpInfo!,
      if (device.openPorts.isEmpty && device.upnpInfo == null) l10n.wifiNoOpenPort,
    ].join(' · ');
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              isKnown
                  ? Icons.phonelink_erase_rounded
                  : Icons.devices_rounded,
              color: isKnown ? AppColors.safe : AppColors.textSecondary,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(device.ip,
                      style: const TextStyle(
                          fontSize: 13.5, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 11.5, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            risk,
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 84,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 12.5, color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 12.5, color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }
}
