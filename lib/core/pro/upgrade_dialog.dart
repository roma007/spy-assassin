import 'package:flutter/material.dart';
import 'package:privacy_camera/l10n/app_localizations.dart';

import '../../core/theme/app_theme.dart';
import 'pro_store.dart';

/// 检测前的 Pro 准入检查：
/// - Pro 用户直接放行；
/// - 免费用户消耗一次今日次数后放行；
/// - 次数耗尽则弹升级引导，用户「立即解锁」（本地模拟）后可继续。
Future<bool> ensureAccess(BuildContext context, {bool consume = true}) async {
  final pro = ProStore.instance;
  if (pro.isPro) return true;
  if (consume && pro.consumeUse()) return true;
  if (!context.mounted) return false;
  final l10n = AppLocalizations.of(context)!;
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      icon: const Icon(Icons.workspace_premium_rounded,
          color: AppColors.primary, size: 40),
      title: Text(l10n.proLimitTitle),
      content: Text(l10n.proUpgradePrompt,
          style: const TextStyle(fontSize: 13.5, height: 1.5)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.proLater),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(l10n.proUnlock),
        ),
      ],
    ),
  );
  if (ok == true) {
    pro.unlock();
    return true;
  }
  return false;
}

/// 整页锁定视图：检测页面被 Pro 门槛拦截时展示。
class ProLockedView extends StatelessWidget {
  const ProLockedView({super.key, this.onUnlock});

  final VoidCallback? onUnlock;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.workspace_premium_rounded,
                size: 64, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(l10n.proTitle,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(
              l10n.proUpgradePrompt,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onUnlock ??
                  () => ensureAccess(context, consume: false),
              icon: const Icon(Icons.lock_open_rounded),
              label: Text(l10n.proUnlock),
            ),
          ],
        ),
      ),
    );
  }
}
