import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../core/app_environment.dart';
import '../domain/models.dart';

class PaymentResult {
  const PaymentResult({
    required this.success,
    required this.message,
    this.paymentId,
  });

  final bool success;
  final String message;
  final String? paymentId;
}

class PaymentRepository {
  PaymentRepository(this._firestore);

  final FirebaseFirestore? _firestore;

  Future<PaymentResult> startPremiumCheckout({
    required String uid,
    required String phoneNumber,
    required int amountInPaise,
  }) async {
    if (!AppEnvironment.hasRazorpay) {
      await _markPremium(uid, paymentId: 'demo_payment');
      return const PaymentResult(
        success: true,
        message: 'Demo premium unlocked. Configure Razorpay for live payments.',
        paymentId: 'demo_payment',
      );
    }

    final razorpay = Razorpay();
    final completer = Completer<PaymentResult>();

    void complete(PaymentResult result) {
      if (!completer.isCompleted) completer.complete(result);
    }

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse response) async {
      await _markPremium(uid, paymentId: response.paymentId ?? 'razorpay_success');
      complete(PaymentResult(
        success: true,
        message: 'Premium membership activated.',
        paymentId: response.paymentId,
      ));
    });
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse response) {
      complete(PaymentResult(
        success: false,
        message: response.message ?? 'Payment failed. Please try again.',
      ));
    });
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (ExternalWalletResponse response) {
      complete(PaymentResult(
        success: false,
        message: 'External wallet selected: ${response.walletName ?? 'unknown'}.',
      ));
    });

    razorpay.open(<String, Object?>{
      'key': AppEnvironment.razorpayKeyId,
      'amount': amountInPaise,
      'currency': 'INR',
      'name': 'FitMitra Premium',
      'description': 'Monthly premium health and wellness membership',
      'prefill': <String, Object?>{
        'contact': phoneNumber,
      },
      'theme': <String, Object?>{
        'color': '#0B6E4F',
      },
    });

    return completer.future.whenComplete(razorpay.clear);
  }

  Future<void> _markPremium(String uid, {required String paymentId}) async {
    if (_firestore == null || uid == 'guest') return;
    final expiresAt = DateTime.now().add(const Duration(days: 30));
    await _firestore.collection('users').doc(uid).set(
      <String, Object?>{
        'membershipTier': MembershipTier.premium.name,
        'premiumExpiresAt': Timestamp.fromDate(expiresAt),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
    await _firestore.collection('payments').doc(paymentId).set(<String, Object?>{
      'uid': uid,
      'provider': 'razorpay',
      'paymentId': paymentId,
      'amountInPaise': 49900,
      'status': 'captured_client_pending_server_verification',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
