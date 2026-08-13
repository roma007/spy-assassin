import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:privacy_camera/l10n/app_localizations.dart';

import '../../core/permissions/permission_helper.dart';
import '../../core/report/report_store.dart';
import '../../core/stats/stat_store.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_widgets.dart';
import 'bluetooth_risk.dart';

/// 蓝牙扫描页：扫描周边 BLE 设备，辅助排查（摄像头蓝牙使用率低，仅作线索）。
class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  StreamSubscription<BluetoothAdapterState>? _adapterSub;
  StreamSubscription<List<ScanResult>>? _resultsSub;
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  bool _scanning = false;
  List<ScanResult> _results = const [];

  @override
  void initState() {
    super.initState();
    _adapterSub = FlutterBluePlus.adapterState.listen((state) {
      if (!mounted) return;
      setState(() => _adapterState = state);
    });
    _requestPermission();
  }

  @override
  void dispose() {
    _adapterSub?.cancel();
    _resultsSub?.cancel();
    FlutterBluePlus.stopScan();
    super.dispose();
  }

  Future<void> _requestPermission() async {
    await PermissionHelper.requestBluetooth();
  }

  Future<void> _startScan() async {
    if (_scanning) return;
    StatStore.instance.recordBle();
    setState(() {
      _scanning = true;
      _results = const [];
    });
    HapticFeedback.mediumImpact();
    _resultsSub = FlutterBluePlus.scanResults.listen((results) {
      if (!mounted) return;
      setState(() => _results = results);
    });
    try {
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 5),
        androidUsesFineLocation: false,
      );
    } catch (_) {}
    if (mounted) {
      setState(() => _scanning = false);
    }
    _recordScanResult(_results);
  }

  /// 扫描完成时记录本次结论到检测报告。
  void _recordScanResult(List<ScanResult> results) {
    final l10n = AppLocalizations.of(context)!;
    final high = results
        .where((r) => assessBluetoothRisk(r.device.platformName) == BleRisk.high)
        .toList();
    final medium = results
        .where((r) =>
            assessBluetoothRisk(r.device.platformName) == BleRisk.medium)
        .toList();
    final risk = high.isNotEmpty
        ? ReportRisk.high
        : medium.isNotEmpty
            ? ReportRisk.low
            : ReportRisk.safe;
    final names = high
        .map((r) =>
            r.device.platformName.isEmpty ? l10n.bleUnnamed : r.device.platformName)
        .toList();
    ReportStore.instance.add(ReportEntry(
      featureKey: 'bluetooth',
      time: DateTime.now(),
      risk: risk,
      summary: l10n.bleSummary(
          results.length, high.length, medium.length, names.take(5).join('、')),
    ));
  }

  Future<void> _turnOnBluetooth() async {
    try {
      await FlutterBluePlus.turnOn();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      children: [
        _buildStatusCard(),
        _buildAction(),
        if (_results.isNotEmpty) _buildResults(),
        SectionCard(
          child: Text(
            l10n.bleDisclaimer,
            style: const TextStyle(
                fontSize: 11.5, color: AppColors.textSecondary, height: 1.5),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard() {
    final l10n = AppLocalizations.of(context)!;
    final on = _adapterState == BluetoothAdapterState.on;
    final turningOn = _adapterState == BluetoothAdapterState.turningOn;
    return SectionCard(
      child: Row(
        children: [
          Icon(
            on ? Icons.bluetooth_connected_rounded : Icons.bluetooth_disabled_rounded,
            color: on ? AppColors.safe : AppColors.textSecondary,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  on
                      ? l10n.bleOn
                      : (turningOn ? l10n.bleTurningOn : l10n.bleOff),
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  on ? l10n.bleOnDesc : l10n.bleOffDesc,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          if (!on)
            TextButton(onPressed: _turnOnBluetooth, child: Text(l10n.bleTurnOn)),
        ],
      ),
    );
  }

  Widget _buildAction() {
    final l10n = AppLocalizations.of(context)!;
    final enabled =
        _adapterState == BluetoothAdapterState.on && !_scanning;
    return SectionCard(
      child: FilledButton.icon(
        onPressed: enabled ? _startScan : null,
        icon: _scanning
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : const Icon(Icons.bluetooth_searching_rounded),
        label: Text(_scanning ? l10n.bleScanning : l10n.bleStartScan),
      ),
    );
  }

  Widget _buildResults() {
    final l10n = AppLocalizations.of(context)!;
    // 高风险在前，其次可疑，再低风险；按 RSSI 强→弱排序。
    final sorted = [..._results]..sort((a, b) {
        final ra = assessBluetoothRisk(a.device.platformName);
        final rb = assessBluetoothRisk(b.device.platformName);
        final byRisk = rb.index.compareTo(ra.index);
        return byRisk != 0 ? byRisk : b.rssi.compareTo(a.rssi);
      });
    final high = sorted
        .where((r) => assessBluetoothRisk(r.device.platformName) == BleRisk.high)
        .length;
    final medium = sorted
        .where((r) => assessBluetoothRisk(r.device.platformName) == BleRisk.medium)
        .length;

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
          for (final r in sorted) _DeviceTile(result: r),
        ],
      ),
    );
  }
}

class _DeviceTile extends StatelessWidget {
  const _DeviceTile({required this.result});

  final ScanResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final name = result.device.platformName;
    final risk = assessBluetoothRisk(name);
    final color = switch (risk) {
      BleRisk.high => AppColors.riskHigh,
      BleRisk.medium => AppColors.riskLow,
      BleRisk.low => AppColors.safe,
    };
    final riskLabel = switch (risk) {
      BleRisk.high => l10n.bleRiskHigh,
      BleRisk.medium => l10n.bleRiskMedium,
      BleRisk.low => l10n.bleRiskLow,
    };
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.bluetooth_audio_rounded, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isEmpty ? l10n.bleUnnamed : name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 13.5, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _RssiBar(rssi: result.rssi),
                    const SizedBox(width: 6),
                    Text('${result.rssi} dBm',
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          RiskChip(label: riskLabel, color: color),
        ],
      ),
    );
  }
}

/// RSSI 距离指示条：-100（远）~ -30（近）。
class _RssiBar extends StatelessWidget {
  const _RssiBar({required this.rssi});

  final int rssi;

  @override
  Widget build(BuildContext context) {
    final ratio = ((rssi.clamp(-100, -30) + 100) / 70).clamp(0.0, 1.0);
    return SizedBox(
      width: 60,
      height: 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: LinearProgressIndicator(
          value: ratio,
          minHeight: 4,
          backgroundColor: AppColors.background,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
