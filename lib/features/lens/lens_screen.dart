import 'dart:async';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:privacy_camera/l10n/app_localizations.dart';

import '../../core/permissions/permission_helper.dart';
import '../../core/report/report_store.dart';
import '../../core/stats/stat_store.dart';
import '../../core/theme/app_theme.dart';
import '../ir/bright_spot_detector.dart';

/// 镜头反光扫描页：昏暗环境 + 手电同轴光，扫描墙面/物体上的圆形反光斑，
/// 特征符合镜头的回反射光斑。比红外更轻，不带动量计与放大镜。
class LensScreen extends StatefulWidget {
  const LensScreen({super.key});

  @override
  State<LensScreen> createState() => _LensScreenState();
}

class _LensScreenState extends State<LensScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  bool _initializing = true;
  bool _permissionDenied = false;
  bool _hasTorch = false;
  bool _torchOn = false;
  bool _useFront = false;
  bool _busy = false;
  bool _confirmed = false;
  bool _hint = false;
  bool _reported = false;
  List<BrightSpot> _spots = const [];
  String? _error;

  /// 连续出现光斑的帧数，>=2 帧才确认（排除单帧噪点）。
  int _hitFrames = 0;

  final _detector = BrightSpotDetector(
    sensitivity: 3.0,
    minCircularity: 0.6,
    minSize: 2,
    maxSize: 9,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _init();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _init();
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _controller?.dispose();
      _controller = null;
    }
  }

  Future<void> _init() async {
    if (!mounted) return;
    setState(() {
      _initializing = true;
      _permissionDenied = false;
      _error = null;
    });
    final granted = await PermissionHelper.requestCamera();
    if (!granted) {
      if (mounted) {
        setState(() {
          _initializing = false;
          _permissionDenied = true;
        });
      }
      return;
    }
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) {
          setState(() => _error = AppLocalizations.of(context)!.irNoCamera);
        }
        return;
      }
      final preferred = cameras
          .where((c) =>
              c.lensDirection ==
              (_useFront ? CameraLensDirection.front : CameraLensDirection.back))
          .toList();
      final camera = preferred.isNotEmpty ? preferred.first : cameras.first;
      final controller = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );
      await controller.initialize();
      await _refreshTorchSupport(controller);
      StatStore.instance.recordLens();
      controller.startImageStream(_onImage);
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _controller = controller;
        _initializing = false;
      });
    } catch (e) {
      if (mounted) {
        setState(
            () => _error = AppLocalizations.of(context)!.lensInitFailed('$e'));
      }
    }
  }

  /// 反光扫描需要同轴光源，初始化后尽量保持手电常亮。
  Future<void> _refreshTorchSupport(CameraController controller) async {
    try {
      await controller.setFlashMode(FlashMode.torch);
      final supported = controller.value.flashMode == FlashMode.torch;
      if (!supported) await controller.setFlashMode(FlashMode.off);
      if (mounted) {
        setState(() {
          _hasTorch = supported;
          _torchOn = supported;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _hasTorch = false);
    }
  }

  void _onImage(CameraImage image) {
    if (_busy) return;
    _busy = true;
    try {
      final spots = _detector.detect(image);
      if (spots.isNotEmpty) {
        _hitFrames++;
        // 持续 >=2 帧且位置相近才算确认
        if (_hitFrames >= 2) {
          final sameSpot = _sameSpot(_spots, spots);
          if (!_confirmed && sameSpot) {
            HapticFeedback.lightImpact();
            if (!_reported) {
              _reported = true;
              ReportStore.instance.add(ReportEntry(
                featureKey: 'lens',
                time: DateTime.now(),
                risk: ReportRisk.high,
                summary: AppLocalizations.of(context)!.lensConfirmedSummary,
              ));
            }
          }
          _confirmed = sameSpot;
          _hint = true;
        } else {
          _confirmed = false;
          _hint = true;
        }
      } else {
        _hitFrames = 0;
        _confirmed = false;
        _hint = false;
      }
      if (mounted) {
        setState(() => _spots = spots);
      }
    } finally {
      _busy = false;
    }
  }

  /// 连续帧光斑中心距离是否足够接近（归一化坐标，阈值 0.06）。
  bool _sameSpot(List<BrightSpot> prev, List<BrightSpot> cur) {
    if (prev.isEmpty || cur.isEmpty) return false;
    final a = prev.reduce((x, y) => x.peakIntensity >= y.peakIntensity ? x : y);
    final b = cur.reduce((x, y) => x.peakIntensity >= y.peakIntensity ? x : y);
    final dx = (a.rect.center.dx - b.rect.center.dx).abs();
    final dy = (a.rect.center.dy - b.rect.center.dy).abs();
    return dx <= 0.06 && dy <= 0.06;
  }

  Future<void> _toggleTorch() async {
    final c = _controller;
    if (c == null || !_hasTorch) return;
    final on = !_torchOn;
    try {
      await c.setFlashMode(on ? FlashMode.torch : FlashMode.off);
      if (mounted) setState(() => _torchOn = on);
    } catch (_) {}
  }

  Future<void> _flipCamera() async {
    final c = _controller;
    if (c == null) return;
    await c.dispose();
    _controller = null;
    setState(() => _useFront = !_useFront);
    await _init();
  }

  @override
  Widget build(BuildContext context) {
    if (_permissionDenied) return _buildPermissionDenied();
    if (_error != null) return _buildError();
    if (_initializing || _controller == null) return const _LoadingView();

    return Column(
      children: [
        _buildGuidanceBanner(),
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              CameraPreview(_controller!),
              CustomPaint(
                painter: _SpotPainter(
                  spots: _spots,
                  confirmed: _confirmed,
                ),
              ),
              if (_confirmed)
                const _ConfirmBanner()
              else if (_hint)
                const _HintBanner(),
            ],
          ),
        ),
        _buildToolbar(),
      ],
    );
  }

  Widget _buildGuidanceBanner() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: AppColors.surfaceLight,
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline_rounded,
              size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.lensGuidance,
              style: const TextStyle(
                  fontSize: 12.5, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: _hasTorch ? _toggleTorch : null,
                icon: const Icon(Icons.flashlight_on_rounded),
                label: Text(_torchOn ? l10n.torchOn : l10n.torchOff),
                style: _torchOn
                    ? FilledButton.styleFrom(backgroundColor: AppColors.primaryDark)
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            IconButton.filled(
              onPressed: _flipCamera,
              icon: const Icon(Icons.flip_camera_ios_rounded),
              tooltip: l10n.lensFlipTooltip,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionDenied() {
    final l10n = AppLocalizations.of(context)!;
    return _MessageView(
      icon: Icons.no_photography_rounded,
      title: l10n.lensPermTitle,
      message: l10n.permissionDenial(l10n.permissionCameraName),
      buttonLabel: l10n.goToSettings,
      onPressed: () => PermissionHelper.openSettings(),
    );
  }

  Widget _buildError() {
    final l10n = AppLocalizations.of(context)!;
    return _MessageView(
      icon: Icons.error_outline_rounded,
      title: l10n.lensErrorTitle,
      message: _error!,
      buttonLabel: l10n.retry,
      onPressed: () => _init(),
    );
  }
}

/// 高亮圆形光斑框选层。
class _SpotPainter extends CustomPainter {
  _SpotPainter({required this.spots, required this.confirmed});

  final List<BrightSpot> spots;
  final bool confirmed;

  @override
  void paint(Canvas canvas, Size size) {
    final color = confirmed ? AppColors.riskHigh : AppColors.riskLow;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    for (final spot in spots) {
      final rect = Rect.fromLTRB(
        spot.rect.left * size.width,
        spot.rect.top * size.height,
        spot.rect.right * size.width,
        spot.rect.bottom * size.height,
      );
      final center = rect.center;
      final radius = max(rect.width, rect.height) * size.width / 2 + 10;
      canvas.drawCircle(center, radius, paint);
      canvas.drawCircle(center, radius + 4, Paint()
        ..color = color.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1);
      canvas.drawLine(
        center - Offset(10, 0),
        center + Offset(10, 0),
        Paint()
          ..color = color.withValues(alpha: 0.8)
          ..strokeWidth = 1.5,
      );
      canvas.drawLine(
        center - Offset(0, 10),
        center + Offset(0, 10),
        Paint()
          ..color = color.withValues(alpha: 0.8)
          ..strokeWidth = 1.5,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SpotPainter oldDelegate) =>
      oldDelegate.spots != spots || oldDelegate.confirmed != confirmed;
}

class _ConfirmBanner extends StatelessWidget {
  const _ConfirmBanner();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.riskHigh,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context)!.lensConfirmBanner,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _HintBanner extends StatelessWidget {
  const _HintBanner();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.riskLow,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.center_focus_weak_rounded, color: Color(0xFF3A2E00), size: 20),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context)!.lensHintBanner,
              style: const TextStyle(color: Color(0xFF3A2E00), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageView extends StatelessWidget {
  const _MessageView({
    required this.icon,
    required this.title,
    required this.message,
    required this.buttonLabel,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String message;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(title,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
            const SizedBox(height: 8),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(height: 20),
            FilledButton(onPressed: onPressed, child: Text(buttonLabel)),
          ],
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(AppLocalizations.of(context)!.startingCamera,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
