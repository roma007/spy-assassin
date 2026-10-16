import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spy_assassin/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_theme.dart';
import 'iap_config.dart';
import 'iap_store.dart';
import 'pro_store.dart';

/// 订阅合规链接：App 审核指南 3.1.2 要求付费墙内必须提供可点击的
/// 「使用条款（EULA）」和「隐私政策」链接。
const String kTermsOfUseUrl =
    'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/';
const String kPrivacyPolicyUrl =
    'https://roma007.github.io/spy-assassin/privacy.html';

/// 进入 Pro 付费流程：Pro 用户直接放行；否则弹出付费墙 [PaywallDialog]，
/// 解锁成功后返回 true。
Future<bool> ensureAccess(BuildContext context) async {
  final pro = ProStore.instance;
  if (pro.isPro) return true;
  if (!context.mounted) return false;
  final ok = await showDialog<bool>(
    context: context,
    builder: (_) => const PaywallDialog(),
  );
  return ok ?? false;
}

/// 检测扫描前的权限检查：
/// - Pro 用户直接放行；
/// - 免费用户仍有免费次数：消耗 1 次并放行；
/// - 免费用户已无次数：弹出付费墙，解锁成功后放行。
Future<bool> ensureScanAccess(BuildContext context) async {
  final pro = ProStore.instance;
  if (pro.isPro) return true;
  if (pro.consumeFreeScan()) return true;
  if (!context.mounted) return false;
  final ok = await showDialog<bool>(
    context: context,
    builder: (_) => const PaywallDialog(scanExhausted: true),
  );
  return ok ?? false;
}

/// Pro 付费墙：选择套餐 → 发起真实 IAP 购买；支持恢复购买。
class PaywallDialog extends StatefulWidget {
  const PaywallDialog({super.key, this.scanExhausted = false});

  /// 是否由"免费扫描次数用尽"触发，用于切换标题文案。
  final bool scanExhausted;

  @override
  State<PaywallDialog> createState() => _PaywallDialogState();
}

class _PaywallDialogState extends State<PaywallDialog> {
  ProPlan _selected = ProPlan.weekly;
  String? _error;
  bool _busy = false;
  bool _restoring = false;

  IapStore get _store => IapStore.instance;

  @override
  void initState() {
    super.initState();
    _store.addListener(_onStoreChanged);
    unawaited(_store.init());
  }

  @override
  void dispose() {
    _store.removeListener(_onStoreChanged);
    super.dispose();
  }

  void _onStoreChanged() {
    if (mounted) setState(() {});
  }

  String _price(ProPlan plan) {
    final details = _store.productFor(plan);
    if (details != null) return details.price;
    if (!_store.isReady) return '…';
    return '—';
  }

  Future<void> _purchase() async {
    if (_busy || _restoring) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final result = await _store.purchase(_selected);
    if (!mounted) return;
    setState(() => _busy = false);
    switch (result) {
      case IapResult.success:
        if (ProStore.instance.isPro) {
          Navigator.of(context).pop(true);
        }
      case IapResult.canceled:
        break;
      case IapResult.failure:
        setState(() {
          _error = _store.isReady
              ? l10n.proIapError
              : l10n.proStoreUnavailable;
        });
    }
  }

  Future<void> _restore() async {
    if (_busy || _restoring) return;
    setState(() {
      _restoring = true;
      _error = null;
    });
    await _store.restorePurchases();
    if (!mounted) return;
    setState(() => _restoring = false);
    if (ProStore.instance.isPro) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _error = _store.isReady
            ? l10n.proRestoreEmpty
            : l10n.proStoreUnavailable;
      });
    }
  }

  /// 在系统浏览器中打开 EULA / 隐私政策链接。
  Future<void> _openExternal(String url) async {
    final messenger = ScaffoldMessenger.maybeOf(context);
    final failedText = l10n.proLinkOpenFailed;
    bool ok;
    try {
      ok = await launchUrl(Uri.parse(url),
          mode: LaunchMode.externalApplication);
    } catch (_) {
      ok = false;
    }
    if (!ok) {
      messenger?.showSnackBar(SnackBar(content: Text(failedText)));
    }
  }

  AppLocalizations get l10n => AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    final loading = _busy || _restoring;
    final title = widget.scanExhausted ? l10n.proScanExhaustedTitle : l10n.proTitle;
    final subtitle = widget.scanExhausted ? l10n.proScanExhaustedMsg : l10n.proUpgradePrompt;
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 26, 24, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.workspace_premium_rounded,
                  color: AppColors.primary, size: 44),
              const SizedBox(height: 10),
              Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 19, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 12.5, color: AppColors.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 18),
              _FeatureList(l10n: l10n),
              const SizedBox(height: 18),
              _PlanCard(
                plan: ProPlan.weekly,
                title: l10n.proPlanWeekly,
                subtitle: l10n.proPlanWeeklySub,
                price: _price(ProPlan.weekly),
                badge: l10n.proMostPopular,
                selected: _selected == ProPlan.weekly,
                onTap: () => setState(() => _selected = ProPlan.weekly),
              ),
              const SizedBox(height: 10),
              _PlanCard(
                plan: ProPlan.monthly,
                title: l10n.proPlanMonthly,
                subtitle: l10n.proPlanMonthlySub,
                price: _price(ProPlan.monthly),
                selected: _selected == ProPlan.monthly,
                onTap: () => setState(() => _selected = ProPlan.monthly),
              ),
              const SizedBox(height: 10),
              _PlanCard(
                plan: ProPlan.yearly,
                title: l10n.proPlanYearly,
                subtitle: l10n.proPlanYearlySub,
                price: _price(ProPlan.yearly),
                badge: l10n.proBestValue,
                selected: _selected == ProPlan.yearly,
                onTap: () => setState(() => _selected = ProPlan.yearly),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.proRenewalNote,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.textSecondary,
                    height: 1.45),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: AppColors.riskHigh),
                ),
              ],
              const SizedBox(height: 16),
              FilledButton(
                onPressed: loading ? null : _purchase,
                child: loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : Text('${l10n.proUnlock} · ${_price(_selected)}'),
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: loading ? null : _restore,
                child: Text(l10n.proRestore,
                    style: const TextStyle(fontSize: 13)),
              ),
              const SizedBox(height: 6),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _LegalLink(
                    label: l10n.proTermsOfUse,
                    onTap:
                        loading ? null : () => _openExternal(kTermsOfUseUrl),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text('·',
                        style: TextStyle(
                            fontSize: 11, color: AppColors.textSecondary)),
                  ),
                  _LegalLink(
                    label: l10n.proPrivacyPolicy,
                    onTap: loading
                        ? null
                        : () => _openExternal(kPrivacyPolicyUrl),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 付费墙中的 Pro 权益列表。
class _FeatureList extends StatelessWidget {
  const _FeatureList({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.all_inclusive_rounded, l10n.proFeatureUnlimitedScan),
      (Icons.picture_as_pdf_rounded, l10n.proFeaturePdfReport),
      (Icons.article_rounded, l10n.proFeatureFullReport),
      (Icons.history_rounded, l10n.proFeatureUnlimitedHistory),
    ];
    return Column(
      children: [
        for (final (icon, text) in items)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(text,
                      style: const TextStyle(fontSize: 13, height: 1.3)),
                ),
                const Icon(Icons.check_circle_rounded,
                    color: AppColors.safe, size: 18),
              ],
            ),
          ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.selected,
    required this.onTap,
    this.badge,
  });

  final ProPlan plan;
  final String title;
  final String subtitle;
  final String price;
  final bool selected;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final borderColor =
        selected ? AppColors.primary : AppColors.textSecondary.withValues(alpha: 0.25);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.10)
              : AppColors.surfaceLight.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: selected ? 1.6 : 1),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: selected ? AppColors.primary : AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontSize: 14.5, fontWeight: FontWeight.w600)),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            badge!,
                            style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 11.5, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(price,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

/// 付费墙底部的合规链接（使用条款 / 隐私政策），带下划线以便审核识别。
class _LegalLink extends StatelessWidget {
  const _LegalLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.primary,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
