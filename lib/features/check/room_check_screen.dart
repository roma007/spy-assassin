import 'package:flutter/material.dart';
import 'package:privacy_camera/l10n/app_localizations.dart';

import '../../core/stats/stat_store.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_widgets.dart';
import '../more/guide_screen.dart';
import 'next_actions_screen.dart';
import 'quick_scan_screen.dart';

/// 房间检查页：把各检测工具串成 4 分钟 Room Check 流程。
class RoomCheckScreen extends StatefulWidget {
  const RoomCheckScreen({super.key});

  @override
  State<RoomCheckScreen> createState() => _RoomCheckScreenState();
}

class _RoomCheckScreenState extends State<RoomCheckScreen> {
  final Map<int, bool> _done = {0: false, 1: false, 2: false, 3: false};
  final Map<int, bool> _suspicious = {0: false, 1: false, 2: false, 3: false};

  DateTime? _startedAt;
  bool _startRecorded = false;
  bool _completedRecorded = false;

  bool get _allDone => _done.values.every((v) => v);
  int get _doneCount => _done.values.where((v) => v).length;
  int get _suspiciousCount => _suspicious.values.where((v) => v).length;

  void _toggleDone(int i) {
    setState(() => _done[i] = !(_done[i] ?? false));
    if (_done[i] == true && !_startRecorded) {
      _startRecorded = true;
      _startedAt = DateTime.now();
      StatStore.instance.recordCheckStarted();
    }
    if (_allDone && !_completedRecorded && _startedAt != null) {
      _completedRecorded = true;
      StatStore.instance
          .recordCheckCompleted(DateTime.now().difference(_startedAt!).inMilliseconds);
    }
  }

  void _toggleSuspicious(int i) {
    setState(() => _suspicious[i] = !(_suspicious[i] ?? false));
  }

  void _openGuide() => Navigator.of(context).push(GuideScreen.route());

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final steps = [
      _StepData(
        icon: Icons.visibility_rounded,
        title: l10n.checkVisualTitle,
        desc: l10n.checkVisualDesc,
        duration: l10n.checkStep1Min,
        hasGuide: true,
      ),
      _StepData(
        icon: Icons.dark_mode_rounded,
        title: l10n.checkIrTitle,
        desc: l10n.checkIrDesc,
        duration: l10n.checkStep1_5Min,
      ),
      _StepData(
        icon: Icons.wifi_rounded,
        title: l10n.checkNetTitle,
        desc: l10n.checkNetDesc,
        duration: l10n.checkStep1_5Min,
      ),
      _StepData(
        icon: Icons.explore_rounded,
        title: l10n.checkMagnetTitle,
        desc: l10n.checkMagnetDesc,
        duration: l10n.checkStep1Min,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabTitleCheck)),
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        children: [
          _QuickScanCard(),
          const SizedBox(height: 8),
          _buildSummaryCard(),
          for (var i = 0; i < steps.length; i++)
            _StepCard(
              data: steps[i],
              index: i + 1,
              checked: _done[i] ?? false,
              suspicious: _suspicious[i] ?? false,
              onToggle: () => _toggleDone(i),
              onToggleSuspicious: () => _toggleSuspicious(i),
              onSkip: () => _toggleDone(i),
              onOpenGuide: steps[i].hasGuide ? _openGuide : null,
            ),
          if (_allDone && _suspiciousCount == 0) const _AllDoneCard(),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final l10n = AppLocalizations.of(context)!;
    final doneRatio = _doneCount / 4;
    return SectionCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircularProgressIndicator(
                value: doneRatio,
                backgroundColor: AppColors.surfaceLight,
                color: _allDone ? AppColors.safe : AppColors.primary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  _allDone ? l10n.checkDone : l10n.checkInProgress,
                  style:
                      const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          if (_suspiciousCount > 0) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(Icons.warning_amber_rounded,
                    color: AppColors.riskHigh, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.checkSuspiciousFound(_suspiciousCount),
                    style: const TextStyle(
                        fontSize: 12.5, color: AppColors.riskHigh),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () =>
                    Navigator.of(context).push(NextActionsScreen.route()),
                icon: const Icon(Icons.health_and_safety_rounded),
                label: Text(l10n.checkNextActions),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.riskHigh,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StepData {
  const _StepData({
    required this.icon,
    required this.title,
    required this.desc,
    required this.duration,
    this.hasGuide = false,
  });

  final IconData icon;
  final String title;
  final String desc;
  final String duration;
  final bool hasGuide;
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.data,
    required this.index,
    required this.checked,
    required this.suspicious,
    required this.onToggle,
    required this.onToggleSuspicious,
    this.onSkip,
    this.onOpenGuide,
  });

  final _StepData data;
  final int index;
  final bool checked;
  final bool suspicious;
  final VoidCallback onToggle;
  final VoidCallback onToggleSuspicious;
  final VoidCallback? onSkip;
  final VoidCallback? onOpenGuide;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SectionCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: suspicious
                          ? AppColors.riskHigh.withValues(alpha: 0.15)
                          : checked
                              ? AppColors.safe.withValues(alpha: 0.15)
                              : AppColors.primary.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      suspicious
                          ? Icons.warning_amber_rounded
                          : checked
                              ? Icons.check_rounded
                              : data.icon,
                      color: suspicious
                          ? AppColors.riskHigh
                          : checked
                              ? AppColors.safe
                              : AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(l10n.checkStepN(index),
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                data.title,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(data.duration,
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(data.desc,
                            style: const TextStyle(
                                fontSize: 12.5,
                                color: AppColors.textSecondary,
                                height: 1.4)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    checked
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color:
                        checked ? AppColors.safe : AppColors.textSecondary,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Row(
              children: [
                if (onOpenGuide != null)
                  TextButton.icon(
                    onPressed: onOpenGuide,
                    icon: const Icon(Icons.menu_book_rounded, size: 16),
                    label: Text(l10n.checkHideoutList),
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                if (onSkip != null && !checked)
                  TextButton(
                    onPressed: onSkip,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    child: Text(l10n.checkSkip),
                  ),
                const Spacer(),
                TextButton.icon(
                  onPressed: onToggleSuspicious,
                  icon: Icon(
                    suspicious
                        ? Icons.warning_amber_rounded
                        : Icons.flag_outlined,
                    size: 16,
                    color: suspicious ? AppColors.riskHigh : null,
                  ),
                  label: Text(
                      suspicious ? l10n.checkMarkedSuspicious : l10n.checkMarkSuspicious),
                  style: TextButton.styleFrom(
                    foregroundColor:
                        suspicious ? AppColors.riskHigh : null,
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AllDoneCard extends StatelessWidget {
  const _AllDoneCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SectionCard(
      child: Column(
        children: [
          const Icon(Icons.verified_rounded, color: AppColors.safe, size: 40),
          const SizedBox(height: 8),
          Text(l10n.checkAllFourDone,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(
            l10n.checkAllDoneTip,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 12.5, color: AppColors.textSecondary, height: 1.4),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () =>
                  Navigator.of(context).push(NextActionsScreen.route()),
              icon: const Icon(Icons.health_and_safety_rounded),
              label: Text(l10n.checkNextActions),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickScanCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SectionCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const QuickScanScreen()),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.flash_on_rounded, color: AppColors.primary, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.quickScanTitle,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(l10n.quickScanSubtitle,
                        style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
