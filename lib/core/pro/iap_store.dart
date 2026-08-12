import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'iap_config.dart';
import 'pro_store.dart';

/// 购买结果。
enum IapResult {
  success,
  canceled,
  failure,
}

/// 应用内购买集成：查询商品、发起购买、恢复购买，并把成功的交易
/// 同步给 [ProStore] 激活权益。
///
/// 本实现采用「本地信任」模型：不做服务端收据校验，交易成功即激活，
/// 到期时间按订阅周期估算。正式上架如需防共享/防伪造，应接入
/// App Store Server API / Google Play Developer API 做服务端校验。
class IapStore extends ChangeNotifier {
  IapStore._();

  static final IapStore instance = IapStore._();

  static final Set<String> _productIds = {ProPlan.monthly.id, ProPlan.yearly.id};

  bool _initialized = false;
  bool _ready = false;
  bool _busy = false;
  String? _lastError;
  Map<String, ProductDetails> _products = const {};
  StreamSubscription<List<PurchaseDetails>>? _sub;
  final Set<String> _completed = {};

  /// 商店是否可用（平台支持且初始化成功）。
  bool get isReady => _ready;

  /// 是否有购买/恢复流程进行中。
  bool get isBusy => _busy;

  /// 最近一次错误信息（用于界面展示）。
  String? get lastError => _lastError;

  /// 指定套餐的实时价格（来自商店），未取到返回 null。
  ProductDetails? productFor(ProPlan plan) => _products[plan.id];

  /// 启动时调用一次：监听交易、查询商品并尝试恢复历史购买。
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    _sub = InAppPurchase.instance.purchaseStream.listen(
      _onPurchases,
      onError: (Object e) {
        _lastError = '$e';
        notifyListeners();
      },
    );
    try {
      _ready = await InAppPurchase.instance.isAvailable();
    } catch (_) {
      _ready = false;
    }
    if (_ready) {
      await _refreshProducts();
      unawaited(restorePurchases());
    }
    notifyListeners();
  }

  Future<void> _refreshProducts() async {
    try {
      final resp = await InAppPurchase.instance.queryProductDetails(_productIds);
      _products = {for (final d in resp.productDetails) d.id: d};
      _lastError = null;
    } catch (e) {
      _lastError = '$e';
    }
    notifyListeners();
  }

  /// 发起购买。成功后 [ProStore] 权益会被激活，返回 [IapResult.success]。
  Future<IapResult> purchase(ProPlan plan) async {
    if (_busy) return IapResult.failure;
    if (!_ready) {
      await init();
      if (!_ready) return IapResult.failure;
    }
    _busy = true;
    _lastError = null;
    notifyListeners();
    final completer = Completer<IapResult>();
    late final StreamSubscription<List<PurchaseDetails>> sub;
    sub = InAppPurchase.instance.purchaseStream.listen((List<PurchaseDetails> list) {
      for (final p in list) {
        if (p.productID != plan.id) continue;
        switch (p.status) {
          case PurchaseStatus.purchased:
          case PurchaseStatus.restored:
            _handlePurchase(p);
            if (!completer.isCompleted) completer.complete(IapResult.success);
          case PurchaseStatus.error:
            if (!completer.isCompleted) {
              completer.complete(IapResult.failure);
            }
          case PurchaseStatus.pending:
            break;
          case PurchaseStatus.canceled:
            if (!completer.isCompleted) completer.complete(IapResult.canceled);
        }
      }
    });
    try {
      var details = productFor(plan);
      if (details == null) {
        await _refreshProducts();
        details = productFor(plan);
      }
      if (details == null) {
        if (!completer.isCompleted) completer.complete(IapResult.failure);
      } else {
        await InAppPurchase.instance
            .buyNonConsumable(purchaseParam: PurchaseParam(productDetails: details));
      }
    } catch (e) {
      _lastError = '$e';
      if (!completer.isCompleted) completer.complete(IapResult.failure);
    }
    final result = await completer.future
        .timeout(const Duration(minutes: 3), onTimeout: () => IapResult.failure);
    await sub.cancel();
    _busy = false;
    notifyListeners();
    return result;
  }

  /// 恢复历史购买（换机/重装）。恢复到的交易经 [_onPurchases] 自动激活权益。
  Future<void> restorePurchases() async {
    if (!_ready) return;
    try {
      await InAppPurchase.instance.restorePurchases();
    } catch (e) {
      _lastError = '$e';
      notifyListeners();
    }
  }

  void _onPurchases(List<PurchaseDetails> details) {
    for (final d in details) {
      switch (d.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _handlePurchase(d);
        case PurchaseStatus.error:
          _lastError = d.error?.message;
          notifyListeners();
        case PurchaseStatus.pending:
        case PurchaseStatus.canceled:
          break;
      }
    }
  }

  void _handlePurchase(PurchaseDetails d) {
    final id = d.purchaseID;
    if (id != null) {
      if (_completed.contains(id)) return;
      _completed.add(id);
    }
    InAppPurchase.instance.completePurchase(d);
    for (final plan in ProPlan.values) {
      if (plan.id == d.productID) {
        ProStore.instance.activateIap(plan: plan);
        break;
      }
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
