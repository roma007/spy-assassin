import 'package:flutter/material.dart';
import 'package:spy_assassin/l10n/app_localizations.dart';

import '../../core/theme/app_theme.dart';
import '../check/check_screen.dart';
import '../ir/ir_screen.dart';
import '../magnet/magnet_screen.dart';
import '../more/more_screen.dart';
import '../wifi/wifi_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  /// 已构建过的 Tab 索引。Tab 按需懒加载：只有用户首次点入时才创建，
  /// 避免启动时 IndexedStack 一次性实例化全部页面——红外/磁力等页面
  /// 在 initState 即开始检测并消耗免费扫描次数，同时初始化会导致
  /// 启动瞬间免费配额被并发消耗、误弹付费墙。
  final Set<int> _built = {0};

  static const _screens = [
    CheckScreen(),
    IrScreen(),
    WifiScreen(),
    MagnetScreen(),
    MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final titles = [
      l10n.tabTitleHub,
      l10n.tabTitleIr,
      l10n.tabTitleWifi,
      l10n.tabTitleMagnet,
      l10n.tabTitleMore,
    ];
    return Scaffold(
      appBar: AppBar(title: Text(titles[_index])),
      body: Column(
        children: [
          if (_index == 0) const _PrivacyPromiseBanner(),
          Expanded(
            child: IndexedStack(
              index: _index,
              children: [
                for (var i = 0; i < _screens.length; i++)
                  if (_built.contains(i))
                    _screens[i]
                  else
                    const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() {
          _index = i;
          _built.add(i);
        }),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.shield_rounded),
            label: l10n.navTabHub,
          ),
          NavigationDestination(
            icon: const Icon(Icons.visibility_rounded),
            label: l10n.navTabIr,
          ),
          NavigationDestination(
            icon: const Icon(Icons.wifi_rounded),
            label: l10n.navTabWifi,
          ),
          NavigationDestination(
            icon: const Icon(Icons.explore_rounded),
            label: l10n.navTabMagnet,
          ),
          NavigationDestination(
            icon: const Icon(Icons.more_horiz_rounded),
            label: l10n.navTabMore,
          ),
        ],
      ),
    );
  }
}

/// 首页常驻的隐私承诺条（无账号 / 无云上传 / 数据不落盘）。
class _PrivacyPromiseBanner extends StatelessWidget {
  const _PrivacyPromiseBanner();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.primary.withValues(alpha: 0.08),
      child: Row(
        children: [
          const Icon(Icons.shield_rounded,
              size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.privacyPromiseBanner,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
