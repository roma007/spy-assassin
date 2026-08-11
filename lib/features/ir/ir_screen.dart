import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:privacy_camera/l10n/app_localizations.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../core/permissions/permission_helper.dart';
import '../../core/pro/upgrade_dialog.dart';
import '../../core/report/report_store.dart';
import '../../core/stats/stat_store.dart';
import '../../core/theme/app_theme.dart';
import 'bright_spot_detector.dart';

/// 红外光检测页：全黑环境下用手机摄像头识别夜视摄像头的红外补光亮点。
class IrScreen extends StatefulWidget {
  const IrScreen({super.key});

  @override
  State<IrScreen> createState() => _IrScreenState();
}

class _IrScreenState extends State<IrScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  bool _initializing = true;
  bool _permissionDenied = false;
  bool _hasTorch = false;
  bool _torchOn = false;
  bool _useFront = false;
  bool _busy = false;
  ResolutionPreset _resolution = ResolutionPreset.medium;
  List<BrightSpot> _spots = const [];
  /// 亮点首次出现时刻，用于判定是否持续 2s 以上。
  DateTime? _spotSince;
  /// 持续 2s 以上 → 高风险（红色报警）。
  bool _alarm = false;
  /// 偶发亮点 → 低风险（黄色提示）。
  bool _lowAlert = false;
  /// 本次进入页面是否已记录报告（避免持续报警重复记录）。
  bool _reported = false;
  /// 手机是否在明显晃动。
  bool _unstable = false;
  /// Pro 门槛：仅首次进入时检查一次。
  bool _accessChecked = false;
  bool _blocked = false;
  String? _error;

  final _detector = BrightSpotDetector();
  StreamSubscription<UserAccelerometerEvent>? _accelSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _watchStability();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _init();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _accelSub?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  /// 加速度计：检测到明显晃动时提示用户保持稳定。
  void _watchStability() {
    _accelSub = userAccelerometerEventStream(
      samplingPeriod: SensorInterval.gameInterval,
    ).listen((e) {
      final mag = sqrt(e.x * e.x + e.y * e.y + e.z * e.z);
      final unstable = mag > 1.0;
      if (unstable != _unstable && mounted) {
        setState(() => _unstable = unstable);
      }
    });
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
    if (!_accessChecked) {
      _accessChecked = true;
      if (!await ensureAccess(context)) {
        if (mounted) setState(() => _blocked = true);
        return;
      }
    }
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
          .where((c) => c.lensDirection == (_useFront ? CameraLensDirection.front : CameraLensDirection.back))
          .toList();
      final camera = preferred.isNotEmpty ? preferred.first : cameras.first;
      final controller = CameraController(
        camera,
        _resolution,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );
      await controller.initialize();
      await _refreshTorchSupport(controller);
      StatStore.instance.recordIr();
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
            () => _error = AppLocalizations.of(context)!.irInitFailed('$e'));
      }
    }
  }

  Future<void> _refreshTorchSupport(CameraController controller) async {
    try {
      await controller.setFlashMode(FlashMode.torch);
      final supported = controller.value.flashMode == FlashMode.torch;
      if (supported) await controller.setFlashMode(FlashMode.off);
      if (mounted) setState(() => _hasTorch = supported);
    } catch (_) {
      if (mounted) setState(() => _hasTorch = false);
    }
  }

  void _onImage(CameraImage image) {
    if (_busy) return;
    _busy = true;
    try {
      final spots = _detector.detect(image);
      final hasSpot = spots.isNotEmpty;
      if (hasSpot) {
        _spotSince ??= DateTime.now();
        final sustained =
            DateTime.now().difference(_spotSince!) >= const Duration(seconds: 2);
        if (sustained && !_alarm) {
          HapticFeedback.vibrate();
          _recordReport(ReportRisk.high,
              AppLocalizations.of(context)!.irSustainedSummary);
        }
        _alarm = sustained;
        _lowAlert = !sustained;
        if (_lowAlert && !_alarm && !_reported) {
          _recordReport(ReportRisk.low,
              AppLocalizations.of(context)!.irOccasionalSummary);
        }
      } else {
        _spotSince = null;
        _alarm = false;
        _lowAlert = false;
      }
      if (mounted) {
        setState(() {
          _spots = spots;
        });
      }
    } finally {
      _busy = false;
    }
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

  /// 记录检测结论（每次进入页面只记录最高风险一条）。
  void _recordReport(ReportRisk risk, String summary) {
    if (_reported) return;
    _reported = true;
    ReportStore.instance.add(ReportEntry(
      featureKey: 'ir',
      time: DateTime.now(),
      risk: risk,
      summary: summary,
    ));
  }

  Future<void> _flipCamera() async {
    final c = _controller;
    if (c == null) return;
    await c.dispose();
    _controller = null;
    setState(() => _useFront = !_useFront);
    await _init();
  }

  Future<void> _changeResolution(ResolutionPreset preset) async {
    if (preset == _resolution) return;
    final c = _controller;
    if (c != null) {
      await c.dispose();
      _controller = null;
    }
    setState(() => _resolution = preset);
    await _init();
  }

  @override
  Widget build(BuildContext context) {
    if (_blocked) {
      return ProLockedView(
        onUnlock: () {
          setState(() => _blocked = false);
          _init();
        },
      );
    }
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
                  alarm: _alarm,
                  zoomIn: _alarm,
                ),
              ),
              if (_alarm)
                const _AlarmBanner()
              else if (_lowAlert)
                const _AlertBanner(),
              if (_spots.isNotEmpty && _detector.lastGrid != null)
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 64),
                    child: SizedBox(
                      width: 120,
                      height: 120,
                      child: CustomPaint(
                        painter: _MagnifierPainter(
                          spot: _strongestSpot,
                          grid: _detector.lastGrid,
                          gridWidth: _detector.gridWidth,
                          gridHeight: _detector.gridHeight,
                        ),
                      ),
                    ),
                  ),
                ),
              if (_unstable) const _StabilityChip(),
            ],
          ),
        ),
        _buildToolbar(),
      ],
    );
  }

  BrightSpot get _strongestSpot =>
      _spots.reduce((a, b) => a.peakIntensity >= b.peakIntensity ? a : b);

  Widget _buildGuidanceBanner() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: AppColors.surfaceLight,
      child: Row(
        children: [
          const Icon(Icons.nights_stay_rounded,
              size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.irGuidance,
              style:
                  const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
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
                    ? FilledButton.styleFrom(
                        backgroundColor: AppColors.primaryDark)
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            IconButton.filled(
              onPressed: _flipCamera,
              icon: const Icon(Icons.flip_camera_ios_rounded),
              tooltip: l10n.irFlipTooltip,
            ),
            const SizedBox(width: 12),
            PopupMenuButton<ResolutionPreset>(
              tooltip: l10n.irResTooltip,
              onSelected: _changeResolution,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: ResolutionPreset.low,
                  child: Text(l10n.irResLow),
                ),
                PopupMenuItem(
                  value: ResolutionPreset.medium,
                  child: Text(l10n.irResMedium),
                ),
                PopupMenuItem(
                  value: ResolutionPreset.high,
                  child: Text(l10n.irResHigh),
                ),
              ],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Icon(
                  _resolution == ResolutionPreset.low
                      ? Icons.landscape_rounded
                      : _resolution == ResolutionPreset.high
                          ? Icons.high_quality_rounded
                          : Icons.filter_center_focus_rounded,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionDenied() {
    final l10n = AppLocalizations.of(context)!;
    return _PermissionView(
      icon: Icons.no_photography_rounded,
      title: l10n.irPermTitle,
      message: l10n.permissionDenial(l10n.permissionCameraName),
      onSettings: () => PermissionHelper.openSettings(),
    );
  }

  Widget _buildError() {
    final l10n = AppLocalizations.of(context)!;
    return _PermissionView(
      icon: Icons.error_outline_rounded,
      title: l10n.irErrorTitle,
      message: _error!,
      onSettings: () => _init(),
    );
  }
}

/// 亮斑叠加绘制层。
class _SpotPainter extends CustomPainter {
  _SpotPainter({required this.spots, required this.alarm, this.zoomIn = false});

  final List<BrightSpot> spots;
  final bool alarm;
  final bool zoomIn;

  @override
  void paint(Canvas canvas, Size size) {
    for (final spot in spots) {
      final rect = Rect.fromLTRB(
        spot.rect.left * size.width,
        spot.rect.top * size.height,
        spot.rect.right * size.width,
        spot.rect.bottom * size.height,
      );
      // 放大框便于观察
      final expanded = rect.inflate(zoomIn ? max(rect.width, rect.height) * 0.9 : 6);
      final color = spot.peakIntensity > 235 ? AppColors.riskHigh : AppColors.riskLow;
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;
      canvas.drawRect(expanded, paint);
      canvas.drawCircle(
        expanded.center,
        zoomIn ? 4 : 3,
        Paint()..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SpotPainter oldDelegate) =>
      oldDelegate.spots != spots || oldDelegate.alarm != alarm;
}

class _AlarmBanner extends StatelessWidget {
  const _AlarmBanner();

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
              AppLocalizations.of(context)!.irAlarmBanner,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

/// 偶发亮点（低风险）提示。
class _AlertBanner extends StatelessWidget {
  const _AlertBanner();

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
            const Icon(Icons.visibility_rounded, color: Color(0xFF3A2E00), size: 20),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context)!.irAlertBanner,
              style: const TextStyle(color: Color(0xFF3A2E00), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

/// 中心放大镜：放大最强亮斑周围的降采样亮度网格。
class _MagnifierPainter extends CustomPainter {
  _MagnifierPainter({
    required this.spot,
    required this.grid,
    required this.gridWidth,
    required this.gridHeight,
  });

  final BrightSpot spot;
  final Float32List? grid;
  final int gridWidth;
  final int gridHeight;

  @override
  void paint(Canvas canvas, Size size) {
    if (grid == null || gridWidth == 0 || gridHeight == 0) return;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = size.shortestSide / 2 - 8;
    if (radius <= 0) return;

    final rect = spot.rect;
    var x0 = (rect.left * gridWidth).floor() - 1;
    var x1 = (rect.right * gridWidth).ceil() + 1;
    var y0 = (rect.top * gridHeight).floor() - 1;
    var y1 = (rect.bottom * gridHeight).ceil() + 1;
    x0 = x0.clamp(0, gridWidth - 1);
    x1 = x1.clamp(1, gridWidth);
    y0 = y0.clamp(0, gridHeight - 1);
    y1 = y1.clamp(1, gridHeight);
    final gw = x1 - x0;
    final gh = y1 - y0;
    if (gw <= 0 || gh <= 0) return;

    final clip = Path()
      ..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: radius));
    canvas.save();
    canvas.clipPath(clip);
    canvas.drawRect(
      Rect.fromCircle(center: Offset(cx, cy), radius: radius).inflate(4),
      Paint()..color = const Color(0xFF000000),
    );

    final cell = min(size.width / gw, size.height / gh) * 0.85;
    final ox = cx - gw * cell / 2;
    final oy = cy - gh * cell / 2;
    for (var yy = y0; yy < y1; yy++) {
      for (var xx = x0; xx < x1; xx++) {
        final v = grid![yy * gridWidth + xx].toInt().clamp(0, 255);
        canvas.drawRect(
          Rect.fromLTWH(ox + (xx - x0) * cell, oy + (yy - y0) * cell, cell, cell),
          Paint()..color = Color.fromARGB(255, v, v, v),
        );
      }
    }
    canvas.restore();

    canvas.drawCircle(
      Offset(cx, cy),
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = AppColors.riskHigh
        ..strokeWidth = 2.5,
    );
    final cross = Paint()
      ..color = const Color(0x55FFFFFF)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(cx, 0), Offset(cx, size.height), cross);
    canvas.drawLine(Offset(0, cy), Offset(size.width, cy), cross);
  }

  @override
  bool shouldRepaint(covariant _MagnifierPainter oldDelegate) =>
      oldDelegate.spot != spot ||
      oldDelegate.grid != grid ||
      oldDelegate.gridWidth != gridWidth;
}

/// 手机晃动提示。
class _StabilityChip extends StatelessWidget {
  const _StabilityChip();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.riskLow, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.screen_lock_rotation_rounded,
                size: 16, color: AppColors.riskLow),
            const SizedBox(width: 6),
            Text(
              AppLocalizations.of(context)!.stabilityChip,
              style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

class _PermissionView extends StatelessWidget {
  const _PermissionView({
    required this.icon,
    required this.title,
    required this.message,
    required this.onSettings,
  });

  final IconData icon;
  final String title;
  final String message;
  final VoidCallback onSettings;

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
            FilledButton(
              onPressed: onSettings,
              child: Text(AppLocalizations.of(context)!.goToSettings),
            ),
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
