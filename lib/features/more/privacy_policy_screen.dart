import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_widgets.dart';

/// 隐私政策页：零数据收集承诺与权限用途说明（商店审核必需）。
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('隐私政策')),
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        children: const [
          _Section(
            title: '我们收集什么',
            body: '零收集。本应用无需注册账号、不含广告 SDK、不接入任何统计或'
                '第三方追踪服务，不使用云服务，所有检测数据（图像、网络扫描结果、'
                '传感器读数）均在您的设备本地内存中处理，不会上传或保存到服务器。',
          ),
          _Section(
            title: '数据如何存储',
            body: '本应用不落盘、不存储任何图像与扫描数据。您主动标记的'
                '"我的设备"列表仅保存在本机（应用内部存储），用于下次扫描时排除'
                '已知设备。卸载应用或清除数据后即彻底删除。',
          ),
          _Section(
            title: '权限用途',
            body: '相机：红外检测与镜头反光扫描，仅在您进入检测页时开启，图像'
                '仅在本地实时分析，绝不记录或上传。\n'
                '本地网络：WiFi 扫描需访问当前局域网中的设备，结果仅在本地显示。\n'
                '定位（Android）：系统要求定位权限才能读取 WiFi 信息，不会获取'
                '您的精确位置，也不会上传位置。\n'
                '蓝牙：仅用于可选的蓝牙设备扫描，扫描结果在本地显示。',
          ),
          _Section(
            title: '检测结果的说明',
            body: '本应用的检测结果仅供参考，不构成任何法律证据。网络扫描只能'
                '发现当前 WiFi 下联网的设备，离线或使用独立供电存储的摄像头无法'
                '被检测到。请结合人工排查使用。',
          ),
          _Section(
            title: '联系方式',
            body: '如对隐私政策有任何疑问，请通过应用商店的开发者联系信息与我们联系。',
          ),
          _Section(
            title: '政策更新',
            body: '本政策如有变更，将在应用内更新此页面内容。您继续使用本应用即'
                '视为接受更新后的政策。生效日期：2026-08-10。',
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(body,
              style: const TextStyle(
                  fontSize: 12.5, color: AppColors.textSecondary, height: 1.7)),
        ],
      ),
    );
  }
}
