import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:privacy_camera/l10n/app_localizations.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../core/pro/upgrade_dialog.dart';
import '../../core/report/report_store.dart';
import '../../core/stats/stat_store.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_widgets.dart';

/// 磁力检测页：用磁力计贴近可疑物体，检测电子设备磁场异常。
class MagnetScreen extends StatefulWidget {
  const MagnetScreen({super.key});

  @override
  State<MagnetScreen> createState() => _MagnetScreenState();
}

class _MagnetScreenState extends State<MagnetScreen> {
  StreamSubscription<MagnetometerEvent>? _sub;
  double _magnitude = 0;
  double _smoothed = 0;
  double _baseline = 0;
  double _threshold = 60.0;
  bool _calibrating = true;
  bool _alarm = false;
  bool _reported = false;
  bool _accessChecked = false;
  bool _blocked = false;
  bool _statRecorded = false;
  final List<double> _history = [];
  DateTime? _aboveSince;

  static const _minThreshold = 30.0;
  static const _maxThreshold = 120.0;
  static const _sustain = Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _start();
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> _start() async {
    if (!_accessChecked) {
      _accessChecked = true;
      if (!await ensureAccess(context)) {
        if (mounted) setState(() => _blocked = true);
        return;
      }
    }
    if (!_statRecorded) {
      _statRecorded = true;
      StatStore.instance.recordMagnet();
    }
    _sub = magnetometerEventStream(samplingPeriod: SensorInterval.normalInterval)
        .listen(_onEvent);
  }

  void _onEvent(MagnetometerEvent e) {
    final mag = sqrt(e.x * e.x + e.y * e.y + e.z * e.z);
    final baseline = _baseline;
    if (_calibrating) return;

    final raw = mag - baseline;
    // 指数移动平均低通滤波：抑制瞬时毛刺
    _smoothed = _smoothed == 0 ? raw : _smoothed * 0.5 + raw * 0.5;
    final delta = _smoothed;

    _history.add(delta);
    if (_history.length > 120) _history.removeAt(0);

    // 连续超过阈值 1s 才报警，避免单点毛刺误报
    var alarmed = false;
    if (delta > _threshold) {
      _aboveSince ??= DateTime.now();
      alarmed = DateTime.now().difference(_aboveSince!) >= _sustain;
    } else {
      _aboveSince = null;
    }

    if (alarmed && !_alarm) {
      HapticFeedback.vibrate();
      _recordReport(delta);
    }
    if (mounted) {
      setState(() {
        _magnitude = delta;
        _alarm = alarmed;
      });
    }
  }

  /// 报警上升沿时记录一次到检测报告。
  void _recordReport(double delta) {
    if (_reported) return;
    _reported = true;
    ReportStore.instance.add(ReportEntry(
      featureKey: 'magnet',
      time: DateTime.now(),
      risk: ReportRisk.high,
      summary: AppLocalizations.of(context)!.magnetSummary(
          delta.toStringAsFixed(0), _threshold.toInt()),
    ));
  }

  void _calibrate() {
    var sum = 0.0;
    var count = 0;
    _sub!.onData((e) {
      sum += sqrt(e.x * e.x + e.y * e.y + e.z * e.z);
      count++;
      if (count >= 20) {
        _sub!.cancel();
        setState(() {
          _baseline = sum / count;
          _calibrating = false;
          _smoothed = 0;
          _aboveSince = null;
          _alarm = false;
        });
        _start();
      }
    });
    setState(() {
      _calibrating = true;
      _baseline = 0;
      _smoothed = 0;
      _aboveSince = null;
      _alarm = false;
      _reported = false;
      _history.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_blocked) {
      return ProLockedView(
        onUnlock: () {
          setState(() => _blocked = false);
          _start();
        },
      );
    }
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      children: [
        _buildGuide(),
        const SizedBox(height: 16),
        _buildGauge(),
        const SizedBox(height: 16),
        _buildThreshold(),
        const SizedBox(height: 16),
        _buildChart(),
        const SizedBox(height: 16),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.magnetUsageTitle,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(
                '${l10n.magnetTip1}\n'
                '${l10n.magnetTip2}\n'
                '${l10n.magnetTip3}\n'
                '${l10n.magnetTip4}',
                style: const TextStyle(
                    fontSize: 12.5, color: AppColors.textSecondary, height: 1.7),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGuide() {
    final l10n = AppLocalizations.of(context)!;
    return SectionCard(
      child: Row(
        children: [
          Icon(
            _calibrating ? Icons.tune_rounded : Icons.check_circle_rounded,
            color: _calibrating ? AppColors.primary : AppColors.safe,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _calibrating ? l10n.magnetCalibrating : l10n.magnetCalibrated,
              style: const TextStyle(fontSize: 13.5),
            ),
          ),
          if (!_calibrating)
            TextButton(onPressed: _calibrate, child: Text(l10n.magnetRecalibrate)),
        ],
      ),
    );
  }

  Widget _buildGauge() {
    final l10n = AppLocalizations.of(context)!;
    final ratio = (_magnitude / (_threshold * 1.5)).clamp(0.0, 1.0);
    return SectionCard(
      child: Column(
        children: [
          Text(
            '${_magnitude.toStringAsFixed(0)} µT',
            style: TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.w700,
              color: _alarm ? AppColors.riskHigh : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _alarm ? l10n.magnetAlarm : l10n.magnetDelta,
            style: TextStyle(
              fontSize: 13,
              color: _alarm ? AppColors.riskHigh : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8,
              backgroundColor: AppColors.surfaceLight,
              color: _alarm ? AppColors.riskHigh : AppColors.primary,
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(l10n.magnetThresholdValue(_threshold.toInt()),
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }

  Widget _buildThreshold() {
    final l10n = AppLocalizations.of(context)!;
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.tune_rounded, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(l10n.magnetThresholdTitle,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const Spacer(),
              Text(l10n.magnetThresholdValue(_threshold.toInt()),
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecondary)),
            ],
          ),
          Slider(
            value: _threshold,
            min: _minThreshold,
            max: _maxThreshold,
            divisions: 18,
            label: l10n.magnetThresholdValue(_threshold.toInt()),
            onChanged: _calibrating
                ? null
                : (v) => setState(() {
                      _threshold = v;
                      _aboveSince = null;
                      _alarm = false;
                    }),
          ),
          Text(l10n.magnetThresholdHint,
              style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildChart() {
    final l10n = AppLocalizations.of(context)!;
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.magnetChart,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: CustomPaint(
              painter: _HistoryPainter(history: _history, threshold: _threshold),
              size: Size.infinite,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryPainter extends CustomPainter {
  const _HistoryPainter({required this.history, required this.threshold});

  final List<double> history;
  final double threshold;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.surfaceLight
      ..strokeWidth = 1;
    for (var i = 1; i < 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final maxY = threshold * 1.5;
    final thresholdY = size.height * (1 - (threshold / maxY));
    canvas.drawLine(
      Offset(0, thresholdY),
      Offset(size.width, thresholdY),
      Paint()
        ..color = AppColors.riskHigh.withValues(alpha: 0.5)
        ..strokeWidth = 1,
    );

    if (history.length < 2) return;
    final path = Path();
    final step = size.width / 119;
    for (var i = 0; i < history.length; i++) {
      final x = i * step;
      final v = history[i].clamp(0.0, maxY) / maxY;
      final y = size.height * (1 - v);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.primary
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant _HistoryPainter oldDelegate) =>
      oldDelegate.history != history || oldDelegate.threshold != threshold;
}
