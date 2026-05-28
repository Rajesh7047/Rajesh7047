import 'dart:async';

import 'package:fitmitra/core/errors/failures.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

/// Razorpay checkout wrapper for premium subscriptions.
class RazorpayService {
  RazorpayService({required this.keyId});

  final String keyId;
  Razorpay? _razorpay;
  Completer<String>? _paymentCompleter;

  void _ensureInitialized() {
    _razorpay ??= Razorpay()
      ..on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleSuccess)
      ..on(Razorpay.EVENT_PAYMENT_ERROR, _handleError)
      ..on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternal);
  }

  void _handleSuccess(PaymentSuccessResponse response) {
    _paymentCompleter?.complete(response.paymentId ?? 'demo_payment');
  }

  void _handleError(PaymentFailureResponse response) {
    _paymentCompleter?.completeError(
      PaymentFailure(response.message ?? 'Payment failed'),
    );
  }

  void _handleExternal(ExternalWalletResponse response) {
    _paymentCompleter?.complete('wallet_${response.walletName}');
  }

  /// Opens Razorpay checkout. In debug without valid keys, simulates success.
  Future<String> checkout({
    required int amountInPaise,
    required String description,
    required String userId,
  }) async {
    if (keyId.contains('placeholder') || keyId.contains('xxxxxxxx')) {
      await Future<void>.delayed(const Duration(seconds: 1));
      return 'demo_payment_${DateTime.now().millisecondsSinceEpoch}';
    }

    _ensureInitialized();
    _paymentCompleter = Completer<String>();

    final options = {
      'key': keyId,
      'amount': amountInPaise,
      'name': 'FitMitra',
      'description': description,
      'prefill': {'contact': userId},
      'theme': {'color': '#2E7D32'},
    };

    _razorpay!.open(options);
    return _paymentCompleter!.future;
  }

  void dispose() {
    _razorpay?.clear();
    _razorpay = null;
  }
}
