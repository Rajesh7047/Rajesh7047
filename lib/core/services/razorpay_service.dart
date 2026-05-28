import 'package:fitmitra/core/constants/app_constants.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  RazorpayService() : _razorpay = Razorpay();

  final Razorpay _razorpay;

  void initialize({
    required void Function(PaymentSuccessResponse response) onSuccess,
    required void Function(PaymentFailureResponse response) onFailure,
    required void Function(ExternalWalletResponse response) onExternalWallet,
  }) {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, onSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, onFailure);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, onExternalWallet);
  }

  void openPremiumCheckout({
    required String contact,
    required String email,
    bool yearly = false,
  }) {
    final amount = yearly
        ? AppConstants.premiumYearlyAmountPaise
        : AppConstants.premiumMonthlyAmountPaise;

    _razorpay.open({
      'key': AppConstants.razorpayKey,
      'amount': amount,
      'name': AppConstants.appName,
      'description': yearly ? 'Premium Yearly Plan' : 'Premium Monthly Plan',
      'prefill': {'contact': contact, 'email': email},
      'theme': {'color': '#00A67D'},
    });
  }

  void dispose() {
    _razorpay.clear();
  }
}
