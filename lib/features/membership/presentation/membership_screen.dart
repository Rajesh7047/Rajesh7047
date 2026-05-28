import 'package:fitmitra/core/services/razorpay_service.dart';
import 'package:fitmitra/features/membership/application/membership_controller.dart';
import 'package:fitmitra/features/membership/domain/membership_tier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class MembershipScreen extends ConsumerStatefulWidget {
  const MembershipScreen({
    required this.userId,
    super.key,
  });

  final String userId;

  @override
  ConsumerState<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends ConsumerState<MembershipScreen> {
  late final RazorpayService _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = RazorpayService()
      ..initialize(
        onSuccess: _onPaymentSuccess,
        onFailure: _onPaymentFailure,
        onExternalWallet: (_) {},
      );
  }

  @override
  void dispose() {
    _razorpay.dispose();
    super.dispose();
  }

  Future<void> _onPaymentSuccess(PaymentSuccessResponse _) async {
    await ref.read(membershipControllerProvider.notifier).markPremium(widget.userId);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Premium membership activated!')),
    );
  }

  void _onPaymentFailure(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment failed: ${response.message ?? 'Unknown error'}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tier = ref.watch(membershipControllerProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Current Plan: ${tier.label}', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                const Text('Premium unlocks full AI insights, mentor sessions, and advanced plans.'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: tier == MembershipTier.premium
              ? null
              : () => _razorpay.openPremiumCheckout(
                    contact: '9999999999',
                    email: 'user@fitmitra.app',
                    yearly: false,
                  ),
          child: const Text('Upgrade to Premium (Monthly)'),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: tier == MembershipTier.premium
              ? null
              : () => _razorpay.openPremiumCheckout(
                    contact: '9999999999',
                    email: 'user@fitmitra.app',
                    yearly: true,
                  ),
          child: const Text('Upgrade to Premium (Yearly)'),
        ),
      ],
    );
  }
}
