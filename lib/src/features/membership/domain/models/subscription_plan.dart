import 'package:fitmitra/src/core/models/membership_tier.dart';

class SubscriptionPlan {
  const SubscriptionPlan({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.priceLabel,
    required this.amountInPaise,
    required this.billingLabel,
    required this.tier,
    required this.features,
    this.isPopular = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final String priceLabel;
  final int amountInPaise;
  final String billingLabel;
  final MembershipTier tier;
  final List<String> features;
  final bool isPopular;
}
