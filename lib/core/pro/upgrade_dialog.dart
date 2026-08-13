import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:privacy_camera/l10n/app_localizations.dart';

import '../../core/theme/app_theme.dart';
import 'iap_config.dart';
import 'iap_store.dart';
import 'pro_store.dart';

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

/// Pro 付费墙：选择套餐 → 发起真实 IAP 购买；支持恢复购买。
class PaywallDialog extends StatefulWidget {
  const PaywallDialog({super.key});

  @override
  State<PaywallDialog> createState() => _PaywallDialogState();
}

class _PaywallDialogState extends State<PaywallDialog> {
  ProPlan _selected = ProPlan.yearly;
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

  AppLocalizations get l10n => AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    final loading = _busy || _restoring;
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
              Text(l10n.proTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 19, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(
                l10n.proUpgradePrompt,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 12.5, color: AppColors.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 18),
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
              _PlanCard(
                plan: ProPlan.monthly,
                title: l10n.proPlanMonthly,
                subtitle: l10n.proPlanMonthlySub,
                price: _price(ProPlan.monthly),
                selected: _selected == ProPlan.monthly,
                onTap: () => setState(() => _selected = ProPlan.monthly),
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
              if (kDebugMode) ...[
                const SizedBox(height: 2),
                TextButton(
                  onPressed: loading
                      ? null
                      : () {
                          ProStore.instance.unlock();
                          Navigator.of(context).pop(true);
                        },
                  child: Text(l10n.proLocalSimUnlock,
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary)),
                ),
              ],
            ],
          ),
        ),
      ),
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
