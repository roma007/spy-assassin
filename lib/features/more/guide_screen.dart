import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_widgets.dart';
import '../check/next_actions_screen.dart';

/// 排查指南：高危点图文清单 + 发现异常后的下一步行动。
class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const GuideScreen());

  static const _points = [
    _GuidePoint(
      icon: Icons.smoke_free_rounded,
      title: '烟雾报警器',
      check: '站在正下方从下往上 / 侧向观察，金属与塑料接缝处常有针孔',
      hint: '黑色机身里最容易藏针孔镜头，务必贴近多看几个角度',
    ),
    _GuidePoint(
      icon: Icons.power_rounded,
      title: '插座孔与插线板',
      check: '观察插座面板是否有不自然的孔洞或凸起，用手电照内部',
      hint: 'USB 插口、充电口、排插侧面都是藏镜头高发区',
    ),
    _GuidePoint(
      icon: Icons.face_retouching_natural_rounded,
      title: '镜子（双面镜）',
      check: '指甲贴镜面：指甲与倒影之间有空隙为普通镜，无空隙需警惕',
      hint: '双面镜后方可能是一间房，但镜子本身也能藏微型镜头',
    ),
    _GuidePoint(
      icon: Icons.image_rounded,
      title: '装饰画',
      check: '检查画框四周、挂画背后的缝隙，是否有多余的洞',
      hint: '画框暗格是经典藏匿点，轻轻按压边框感受是否有异',
    ),
    _GuidePoint(
      icon: Icons.air_rounded,
      title: '空调出风口',
      check: '对出风口内部用手电照射，观察格栅间是否有异常反光体',
      hint: '挂机空调顶部与墙体之间也容易塞入微型设备',
    ),
    _GuidePoint(
      icon: Icons.alarm_rounded,
      title: '床头电子钟 / 台灯',
      check: '屏幕面板、按键缝隙、底座是否有额外的孔',
      hint: '紧贴床头的电子设备既是隐蔽点又贴近你，优先级最高',
    ),
    _GuidePoint(
      icon: Icons.router_rounded,
      title: '路由器 / 电视盒子',
      check: '观察 LED 是否有异常的额外指示灯或针孔',
      hint: '路由器常被改装成"合法外衣"藏摄像头',
    ),
    _GuidePoint(
      icon: Icons.local_florist_rounded,
      title: '花盆 / 绿植',
      check: '检查花盆、土壤上方枝叶间是否有异物',
      hint: '叶片遮挡下的微型镜头很难被直接看到，配合红外扫描',
    ),
    _GuidePoint(
      icon: Icons.light_rounded,
      title: '灯具 / 烟雾探测器',
      check: '灯罩内、吊灯连接处、床头壁灯背面逐一检查',
      hint: '光源附近的光晕会干扰肉眼，用红外检测扫过更可靠',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('排查指南')),
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        children: [
          SectionCard(
            child: Text(
              '先视觉排查，再用工具逐个验证。以下是最常见的藏匿位置，建议按顺序过一遍。',
              style: const TextStyle(
                  fontSize: 12.5, color: AppColors.textSecondary, height: 1.5),
            ),
          ),
          for (var i = 0; i < _points.length; i++) _PointCard(point: _points[i], index: i + 1),
          SectionCard(
            child: FilledButton.icon(
              onPressed: () =>
                  Navigator.of(context).push(NextActionsScreen.route()),
              icon: const Icon(Icons.health_and_safety_rounded),
              label: const Text('发现可疑？查看下一步行动'),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuidePoint {
  const _GuidePoint({
    required this.icon,
    required this.title,
    required this.check,
    required this.hint,
  });

  final IconData icon;
  final String title;
  final String check;
  final String hint;
}

class _PointCard extends StatelessWidget {
  const _PointCard({required this.point, required this.index});

  final _GuidePoint point;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(point.icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$index. ${point.title}',
                    style: const TextStyle(
                        fontSize: 14.5, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text('怎么看：${point.check}',
                    style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textPrimary,
                        height: 1.5)),
                const SizedBox(height: 4),
                Text('提示：${point.hint}',
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
