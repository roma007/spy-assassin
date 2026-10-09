import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:spy_assassin/l10n/app_localizations.dart';

import '../../core/permissions/permission_helper.dart';
import '../../core/report/report_store.dart';
import '../../core/stats/stat_store.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_widgets.dart';
import 'tracker_identify.dart';

/// 一键扫描步骤页：进入即自动单轮 BLE 扫描，识别已知追踪器，点「继续」返回。
class TrackerQuickStepScreen extends StatefulWidget {
  const TrackerQuickStepScreen({super.key});

  @override
  State<TrackerQuickStepScreen> createState() => _TrackerQuickStepScreenState();
}

class _TrackerQuickStepScreenState extends State<TrackerQuickStepScreen> {
  static const _scanTimeout = Duration(seconds: 10);

  StreamSubscription<BluetoothAdapterState>? _adapterSub;
  StreamSubscription<List<ScanResult>>? _resultsSub;
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;

  bool _requesting = false;
  bool _scanning = false;
  bool _done = false;
  String? _error;
  int _trackerCount = 0;

  @override
  void initState() {
    super.initState();
    _adapterSub = FlutterBluePlus.adapterState.listen((state) {
      if (!mounted) return;
      setState(() => _adapterState = state);
      if (state == BluetoothAdapterState.on && !_scanning && !_done) {
        _startScan();
      }
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
    setState(() => _requesting = true);
    await PermissionHelper.requestBluetooth();
    setState(() => _requesting = false);
    if (_adapterState == BluetoothAdapterState.on && !_scanning && !_done) {
      _startScan();
    }
  }

  Future<void> _startScan() async {
    if (_scanning || _done) return;
    if (_adapterState == BluetoothAdapterState.turningOn) return;
    if (_adapterState != BluetoothAdapterState.on) {
      await _turnOnBluetooth();
      return;
    }
    StatStore.instance.recordTracker();
    setState(() {
      _scanning = true;
      _done = false;
      _error = null;
      _trackerCount = 0;
    });
    HapticFeedback.mediumImpact();
    final candidates = <_TrackerCandidate>[];
    _resultsSub?.cancel();
    _resultsSub = FlutterBluePlus.scanResults.listen((results) {
      if (!mounted) return;
      candidates.clear();
      for (final r in results) {
        final match = identifyTracker(r.advertisementData.manufacturerData);
        if (match != null) {
          candidates.add(_TrackerCandidate(rssi: r.rssi, kind: match.kind));
        }
      }
    });
    try {
      await FlutterBluePlus.startScan(
        timeout: _scanTimeout,
        androidUsesFineLocation: false,
      );
    } catch (_) {
      if (mounted) {
        setState(() {
          _scanning = false;
          _error = AppLocalizations.of(context)!.trackerScanFailed;
        });
        return;
      }
    }
    if (!mounted) return;
    final count = candidates.length;
    setState(() {
      _trackerCount = count;
      _scanning = false;
      _done = true;
    });
    ReportStore.instance.add(ReportEntry(
      featureKey: 'tracker',
      time: DateTime.now(),
      risk: count > 0 ? ReportRisk.high : ReportRisk.safe,
      summary: count == 0
          ? AppLocalizations.of(context)!.trackerReportSummaryNone
          : AppLocalizations.of(context)!.trackerFoundCandidates(count),
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
    final on = _adapterState == BluetoothAdapterState.on;
    final turningOn = _adapterState == BluetoothAdapterState.turningOn;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.trackerTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 状态卡片
            SectionCard(
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
                          on ? l10n.bleOn : (turningOn ? l10n.bleTurningOn : l10n.bleOff),
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          on ? l10n.bleOnDesc : l10n.bleOffDesc,
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  if (!on)
                    TextButton(onPressed: _turnOnBluetooth, child: Text(l10n.bleTurnOn)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // 扫描状态
            SectionCard(
              child: Row(
                children: [
                  if (_scanning) ...[
                    const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(l10n.trackerScanning)),
                  ] else if (_done) ...[
                    Icon(
                      _trackerCount == 0 ? Icons.shield_rounded : Icons.warning_amber_rounded,
                      color: _trackerCount == 0 ? AppColors.safe : AppColors.riskHigh,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _trackerCount == 0
                            ? l10n.trackerNoTracker
                            : l10n.trackerFoundCandidates(_trackerCount),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _trackerCount == 0 ? AppColors.safe : AppColors.riskHigh,
                        ),
                      ),
                    ),
                  ] else ...[
                    const Icon(Icons.schedule_rounded, color: AppColors.textSecondary, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _requesting ? l10n.checkInProgress : l10n.trackerStartScan,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            // 说明
            SectionCard(
              child: Text(
                l10n.trackerIntro,
                style: const TextStyle(
                    fontSize: 12.5, color: AppColors.textSecondary, height: 1.5),
              ),
            ),
            const SizedBox(height: 12),
            SectionCard(
              child: Text(
                l10n.trackerDisclaimer,
                style: const TextStyle(
                    fontSize: 11.5, color: AppColors.textSecondary, height: 1.5),
              ),
            ),
            // 底部继续按钮
            if (_done || _error != null) ...[
              const Spacer(),
              if (_error != null)
                SectionCard(
                  child: Text(_error!, style: const TextStyle(color: AppColors.riskHigh)),
                ),
              if (_trackerCount > 0) _buildGuidance(),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: Text(l10n.checkNextActions),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGuidance() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.riskHigh.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.trackerGuidanceTitle,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.riskHigh)),
          const SizedBox(height: 6),
          for (final text in [
            l10n.trackerGuidance1,
            l10n.trackerGuidance2,
            l10n.trackerGuidance3,
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text('• $text',
                  style: const TextStyle(
                      fontSize: 12, height: 1.5, color: AppColors.textPrimary)),
            ),
        ],
      ),
    );
  }
}

class _TrackerCandidate {
  const _TrackerCandidate({required this.rssi, required this.kind});
  final int rssi;
  final TrackerKind kind;
}
