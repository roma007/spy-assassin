import 'package:flutter/material.dart';
import 'package:privacy_camera/l10n/app_localizations.dart';

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

  final _screens = const [
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
          Expanded(child: IndexedStack(index: _index, children: _screens)),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
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
