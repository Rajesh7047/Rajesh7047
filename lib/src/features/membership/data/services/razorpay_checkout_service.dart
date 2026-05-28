import 'dart:async';

import 'package:fitmitra/src/core/config/app_config.dart';
import 'package:fitmitra/src/features/auth/domain/models/user_profile.dart';
import 'package:fitmitra/src/features/membership/domain/models/subscription_plan.dart';
import 'package:flutter/foundation.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentResult {
  const PaymentResult({
    required this.isSuccess,
    required this.message,
    this.paymentId,
  });

  final bool isSuccess;
  final String message;
  final String? paymentId;
}

class RazorpayCheckoutService {
  Future<PaymentResult> openCheckout({
    required SubscriptionPlan plan,
    required UserProfile user,
  }) async {
    if (plan.amountInPaise == 0) {
      return const PaymentResult(
        isSuccess: true,
        message: 'Free plan activated.',
      );
    }

    final isMobile =
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);

    if (!isMobile || AppConfig.razorpayKeyId.isEmpty) {
      return const PaymentResult(
        isSuccess: true,
        message:
            'Demo premium activation completed. Add your Razorpay key with --dart-define to enable real checkout.',
      );
    }

    final completer = Completer<PaymentResult>();
    final razorpay = Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (dynamic response) {
      final success = response as PaymentSuccessResponse;
      if (!completer.isCompleted) {
        completer.complete(
          PaymentResult(
            isSuccess: true,
            message: 'Payment successful.',
            paymentId: success.paymentId,
          ),
        );
      }
      razorpay.clear();
    });

    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (dynamic response) {
      final failure = response as PaymentFailureResponse;
      if (!completer.isCompleted) {
        completer.complete(
          PaymentResult(
            isSuccess: false,
            message: failure.message ?? 'Payment failed.',
          ),
        );
      }
      razorpay.clear();
    });

    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (dynamic response) {
      final wallet = response as ExternalWalletResponse;
      if (!completer.isCompleted) {
        completer.complete(
          PaymentResult(
            isSuccess: true,
            message:
                'Checkout completed with ${wallet.walletName ?? 'external wallet'}.',
          ),
        );
      }
      razorpay.clear();
    });

    razorpay.open({
      'key': AppConfig.razorpayKeyId,
      'amount': plan.amountInPaise,
      'name': 'FitMitra',
      'description': plan.title,
      'prefill': {'contact': user.phoneNumber},
      'theme': {'color': '#00A878'},
    });

    return completer.future.timeout(
      const Duration(minutes: 5),
      onTimeout: () {
        razorpay.clear();
        return const PaymentResult(
          isSuccess: false,
          message: 'Razorpay checkout timed out.',
        );
      },
    );
  }
}
