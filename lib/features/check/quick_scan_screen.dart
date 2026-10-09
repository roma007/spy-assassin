import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spy_assassin/l10n/app_localizations.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_widgets.dart';
import '../ir/ir_screen.dart';
import '../magnet/magnet_screen.dart';
import '../tracker/tracker_quick_step.dart';
import '../wifi/wifi_screen.dart';
import 'verdict_screen.dart';

/// 一键扫描页：按顺序自动跑完 红外 → WiFi → 磁力，最后跳转结论页。
class QuickScanScreen extends StatefulWidget {
  const QuickScanScreen({super.key});

  @override
  State<QuickScanScreen> createState() => _QuickScanScreenState();
}

class _QuickScanScreenState extends State<QuickScanScreen> {
  int _currentStep = 0;
  bool _running = false;
  bool _done = false;
  String? _error;

  static final _steps = [
    _QuickStep(
      key: 'ir',
      screenBuilder: (context) => const IrScreen(),
    ),
    _QuickStep(
      key: 'wifi',
      screenBuilder: (context) => const WifiScreen(),
    ),
    _QuickStep(
      key: 'magnet',
      screenBuilder: (context) => const MagnetScreen(),
    ),
    _QuickStep(
      key: 'tracker',
      screenBuilder: (context) => const TrackerQuickStepScreen(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _runScan();
  }

  Future<void> _runScan() async {
    setState(() => _running = true);
    for (int i = 0; i < _steps.length; i++) {
      if (!mounted) return;
      setState(() => _currentStep = i);
      try {
        final step = _steps[i];
        await Navigator.of(context).push(
          MaterialPageRoute(builder: step.screenBuilder),
        );
      } catch (e) {
        _error = e.toString();
        break;
      }
    }
    if (mounted) {
      setState(() {
        _running = false;
        _done = true;
      });
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const VerdictScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.quickScanTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.quickScanSubtitle,
              style: const TextStyle(fontSize: 15, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            if (_error != null)
              SectionCard(
                child: Text(_error!, style: const TextStyle(color: AppColors.riskHigh)),
              )
            else ...[
              for (int i = 0; i < _steps.length; i++) ...[
                _StepTile(
                  step: _steps[i],
                  l10n: l10n,
                  state: i < _currentStep
                      ? _StepState.done
                      : i == _currentStep && _running
                          ? _StepState.running
                          : _StepState.pending,
                ),
                const SizedBox(height: 12),
              ],
            ],
            if (_done) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const VerdictScreen()),
                ),
                icon: const Icon(Icons.verified_rounded),
                label: Text(l10n.quickScanDone),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _QuickStep {
  const _QuickStep({
    required this.key,
    required this.screenBuilder,
  });

  final String key;
  final Widget Function(BuildContext) screenBuilder;
}

String _stepTitle(AppLocalizations l10n, _QuickStep step) => switch (step.key) {
      'ir' => l10n.quickScanStepIr,
      'wifi' => l10n.quickScanStepWifi,
      'magnet' => l10n.quickScanStepMagnet,
      'tracker' => l10n.quickScanStepTracker,
      _ => step.key,
    };

enum _StepState { pending, running, done }

class _StepTile extends StatelessWidget {
  const _StepTile({
    required this.step,
    required this.l10n,
    required this.state,
  });

  final _QuickStep step;
  final AppLocalizations l10n;
  final _StepState state;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (state) {
      _StepState.pending => (
          Icons.radio_button_unchecked,
          AppColors.textSecondary,
        ),
      _StepState.running => (
          Icons.schedule,
          AppColors.primary,
        ),
      _StepState.done => (
          Icons.check_circle_rounded,
          AppColors.safe,
        ),
    };

    return SectionCard(
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _stepTitle(l10n, step),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          if (state == _StepState.running)
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
        ],
      ),
    );
  }
}