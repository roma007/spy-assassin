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
import 'tracker_session.dart';

/// 随身防跟踪扫描页：多轮 BLE 扫描识别已知追踪器，判定是否疑似同行。
class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  static const _scanTimeout = Duration(seconds: 10);

  StreamSubscription<BluetoothAdapterState>? _adapterSub;
  StreamSubscription<List<ScanResult>>? _resultsSub;
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  bool _scanning = false;
  bool _finished = false;
  String? _scanError;

  final _session = TrackerSession();
  List<ScanResult> _latestResults = const [];

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
    if (_adapterState != BluetoothAdapterState.on) {
      await _turnOnBluetooth();
      return;
    }
    StatStore.instance.recordTracker();
    setState(() {
      _scanning = true;
      _finished = false;
      _scanError = null;
      _latestResults = const [];
    });
    HapticFeedback.mediumImpact();
    _resultsSub?.cancel();
    _resultsSub = FlutterBluePlus.scanResults.listen((results) {
      if (!mounted) return;
      setState(() => _latestResults = results);
    });
    try {
      await FlutterBluePlus.startScan(
        timeout: _scanTimeout,
        androidUsesFineLocation: false,
      );
    } catch (_) {
      if (mounted) {
        setState(() =>
            _scanError = AppLocalizations.of(context)!.trackerScanFailed);
      }
    }
    if (_scanError == null) {
      _session.beginRound();
      _recordRound(_latestResults);
    }
    if (mounted) setState(() => _scanning = false);
  }

  /// 一轮扫描结束：记录识别为追踪器的设备。
  void _recordRound(List<ScanResult> results) {
    for (final r in results) {
      final match = identifyTracker(r.advertisementData.manufacturerData);
      if (match == null) continue;
      _session.addSighting(TrackerSighting(
        deviceId: r.device.remoteId.str,
        rssi: r.rssi,
        kind: match.kind,
      ));
    }
  }

  Future<void> _turnOnBluetooth() async {
    try {
      await FlutterBluePlus.turnOn();
    } catch (_) {}
  }

  /// 完成检查：写入检测报告并展示结论。
  void _finish() {
    if (_finished) return;
    final l10n = AppLocalizations.of(context)!;
    final rows = _buildRows();
    final trackers =
        rows.where((r) => r.sighting != null).toList(growable: false);
    final repeated =
        trackers.where((r) => r.motion == TrackerMotion.repeated).length;
    final risk = repeated > 0
        ? ReportRisk.high
        : trackers.isNotEmpty
            ? ReportRisk.low
            : ReportRisk.safe;
    final summary = trackers.isEmpty
        ? l10n.trackerReportSummaryNone
        : l10n.trackerReportSummary(
            _session.round, trackers.length, repeated);
    ReportStore.instance.add(ReportEntry(
      featureKey: 'tracker',
      time: DateTime.now(),
      risk: risk,
      summary: summary,
    ));
    setState(() => _finished = true);
  }

  void _restart() {
    _session.reset();
    setState(() {
      _finished = false;
      _scanError = null;
      _latestResults = const [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.trackerTitle)),
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        children: [
          if (_finished) _buildConclusion(),
          _buildIntro(),
          if (_scanError != null) _buildErrorCard(),
          _buildStatusCard(),
          _buildAction(),
          if (_session.round > 0 && !_scanning && !_finished && _scanError == null)
            _buildProgress(),
          if (_session.allDeviceIds.isNotEmpty &&
              !_scanning &&
              !_finished &&
              _scanError == null)
            _buildResults(),
          SectionCard(
            child: Text(
              l10n.trackerDisclaimer,
              style: const TextStyle(
                  fontSize: 11.5, color: AppColors.textSecondary, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntro() {
    final l10n = AppLocalizations.of(context)!;
    return SectionCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.radar_rounded,
                color: AppColors.primary, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              l10n.trackerIntro,
              style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                  height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard() {
    return SectionCard(
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: AppColors.riskHigh, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _scanError!,
              style: const TextStyle(
                  fontSize: 12.5, color: AppColors.textPrimary, height: 1.5),
            ),
          ),
        ],
      ),
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
                  style:
                      const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : Icon(_session.round > 0
                ? Icons.replay_rounded
                : Icons.bluetooth_searching_rounded),
        label: Text(_scanning
            ? l10n.trackerScanning
            : (_session.round > 0 ? l10n.trackerScanAgain : l10n.trackerStartScan)),
      ),
    );
  }

  Widget _buildProgress() {
    final l10n = AppLocalizations.of(context)!;
    final hasTrackers = _buildRows().any((r) => r.sighting != null);
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.trackerRoundsDone(_session.round),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            hasTrackers
                ? l10n.trackerMoveHint
                : l10n.trackerRoundsTip,
            style: const TextStyle(
                fontSize: 12.5, color: AppColors.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _finish,
              icon: const Icon(Icons.verified_rounded),
              label: Text(l10n.trackerFinish),
            ),
          ),
        ],
      ),
    );
  }

  List<_TrackerRow> _buildRows() {
    final rows = <_TrackerRow>[];
    for (final id in _session.allDeviceIds) {
      final latest = _session.latest(id);
      if (latest == null) continue;
      final roundsSeen = _session.roundsSeen(id);
      rows.add(_TrackerRow(
        sighting: latest,
        roundsSeen: roundsSeen,
        motion: assessTrackerMotion(roundsSeen, latest.rssi),
      ));
    }
    rows.sort((a, b) {
      final at = a.sighting != null ? 0 : 1;
      final bt = b.sighting != null ? 0 : 1;
      if (at != bt) return at.compareTo(bt);
      final am = a.sighting != null && a.motion == TrackerMotion.repeated ? 0 : 1;
      final bm = b.sighting != null && b.motion == TrackerMotion.repeated ? 0 : 1;
      if (am != bm) return am.compareTo(bm);
      return b.sighting!.rssi.compareTo(a.sighting!.rssi);
    });
    return rows;
  }

  Widget _buildResults() {
    final rows = _buildRows();
    final trackers =
        rows.where((r) => r.sighting != null).toList(growable: false);
    final others = _latestResults
        .where((r) =>
            identifyTracker(r.advertisementData.manufacturerData) == null)
        .toList(growable: false)
      ..sort((a, b) => b.rssi.compareTo(a.rssi));

    return Column(
      children: [
        if (trackers.isNotEmpty) _buildTrackerSection(trackers),
        if (others.isNotEmpty) _buildOthersSection(others),
        if (trackers.isEmpty) _buildNoneSection(),
      ],
    );
  }

  Widget _buildTrackerSection(List<_TrackerRow> trackers) {
    final l10n = AppLocalizations.of(context)!;
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(l10n.trackerSectionTrackers,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
              const Spacer(),
              Text(l10n.trackerFoundCandidates(trackers.length),
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 12),
          for (final row in trackers) _TrackerTile(row: row),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _finish,
              icon: const Icon(Icons.health_and_safety_rounded),
              label: Text(l10n.trackerFinish),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOthersSection(List<ScanResult> others) {
    return SectionCard(
      padding: EdgeInsets.zero,
      child: _OthersSection(results: others),
    );
  }

  Widget _buildNoneSection() {
    final l10n = AppLocalizations.of(context)!;
    return SectionCard(
      child: Column(
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.safe, size: 40),
          const SizedBox(height: 8),
          Text(l10n.trackerNoTracker,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(
            l10n.trackerNoTrackerTip,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 12.5, color: AppColors.textSecondary, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildConclusion() {
    final l10n = AppLocalizations.of(context)!;
    final rows = _buildRows();
    final trackers =
        rows.where((r) => r.sighting != null).toList(growable: false);
    final repeated =
        trackers.where((r) => r.motion == TrackerMotion.repeated).length;
    final safe = trackers.isEmpty;
    return SectionCard(
      child: Column(
        children: [
          Icon(
            safe ? Icons.verified_rounded : Icons.warning_amber_rounded,
            color: safe ? AppColors.safe : AppColors.riskHigh,
            size: 40,
          ),
          const SizedBox(height: 8),
          Text(
            safe ? l10n.trackerSafeTitle : l10n.trackerRiskTitle,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            safe
                ? l10n.trackerSafeDesc
                : (repeated > 0
                    ? l10n.trackerRiskRepeated(repeated)
                    : l10n.trackerRiskOnce(trackers.length)),
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 12.5, color: AppColors.textSecondary, height: 1.5),
          ),
          if (!safe) ...[
            const SizedBox(height: 14),
            _GuidanceCard(),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _restart,
              icon: const Icon(Icons.replay_rounded),
              label: Text(l10n.trackerRestart),
            ),
          ),
        ],
      ),
    );
  }
}

/// 单行追踪器/设备视图。
class _TrackerTile extends StatelessWidget {
  const _TrackerTile({required this.row});

  final _TrackerRow row;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sighting = row.sighting!;
    final color = switch (row.motion) {
      TrackerMotion.repeated => AppColors.riskHigh,
      TrackerMotion.once => AppColors.riskLow,
      TrackerMotion.regular => AppColors.safe,
    };
    final motionLabel = switch (row.motion) {
      TrackerMotion.repeated => l10n.trackerMotionRepeated,
      TrackerMotion.once => l10n.trackerMotionOnce,
      TrackerMotion.regular => l10n.trackerMotionRegular,
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
          const Icon(Icons.gps_fixed_rounded, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _brandLabel(l10n, sighting.kind),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 13.5, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _RssiBar(rssi: sighting.rssi),
                    const SizedBox(width: 6),
                    Text('${sighting.rssi} dBm · ${_distanceLabel(l10n, sighting.rssi)}',
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          RiskChip(label: motionLabel, color: color),
        ],
      ),
    );
  }

  String _distanceLabel(AppLocalizations l10n, int rssi) {
    if (rssi >= -55) return l10n.trackerDistanceNear;
    if (rssi >= -75) return l10n.trackerDistanceMid;
    return l10n.trackerDistanceFar;
  }
}

String _brandLabel(AppLocalizations l10n, TrackerKind kind) =>
    switch (kind) {
      TrackerKind.findMy => l10n.trackerBrandFindMy,
      TrackerKind.samsungSmartTag => l10n.trackerBrandSamsung,
      TrackerKind.tile => l10n.trackerBrandTile,
      TrackerKind.google => l10n.trackerBrandGoogle,
    };

/// 「其他蓝牙设备」折叠区。
class _OthersSection extends StatefulWidget {
  const _OthersSection({required this.results});

  final List<ScanResult> results;

  @override
  State<_OthersSection> createState() => _OthersSectionState();
}

class _OthersSectionState extends State<_OthersSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final results = widget.results;
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.devices_other_rounded,
                    color: AppColors.textSecondary, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.trackerSectionOthers(results.length),
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
                Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
        if (_expanded)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Column(
              children: [
                for (final r in results)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.bluetooth_audio_rounded,
                            size: 18, color: AppColors.textSecondary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            r.device.platformName.isEmpty
                                ? l10n.bleUnnamed
                                : r.device.platformName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12.5),
                          ),
                        ),
                        Text('${r.rssi} dBm',
                            style: const TextStyle(
                                fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

/// 发现可疑追踪器后的行动指引。
class _GuidanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
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
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.riskHigh)),
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

/// 行视图数据。
class _TrackerRow {
  const _TrackerRow({
    required this.sighting,
    required this.roundsSeen,
    required this.motion,
  });

  final TrackerSighting? sighting;
  final int roundsSeen;
  final TrackerMotion motion;
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
