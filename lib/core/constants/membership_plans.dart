import 'package:fitmitra/domain/entities/membership_plan.dart';

/// Free and premium membership tiers with Razorpay pricing (INR).
class MembershipPlans {
  MembershipPlans._();

  static const free = MembershipPlan(
    id: 'free',
    name: 'Free',
    priceInPaise: 0,
    durationDays: 365,
    features: [
      'Basic calorie & water tracking',
      '5 AI health messages / day',
      'Limited yoga & meditation previews',
      'Community recipes (free tier)',
    ],
    isPremium: false,
  );

  static const premiumMonthly = MembershipPlan(
    id: 'premium_monthly',
    name: 'Premium Monthly',
    priceInPaise: 49900,
    durationDays: 30,
    features: [
      'Unlimited AI health coach',
      'Personalized diet plans',
      'Full yoga, meditation & recipe library',
      'Live Zoom mentor sessions',
      'Goal-based product recommendations',
      'Priority support',
    ],
    isPremium: true,
  );

  static const premiumYearly = MembershipPlan(
    id: 'premium_yearly',
    name: 'Premium Yearly',
    priceInPaise: 399900,
    durationDays: 365,
    features: [
      'Everything in Premium Monthly',
      'Save 33% vs monthly',
      'Exclusive wellness webinars',
    ],
    isPremium: true,
  );

  static List<MembershipPlan> get all => [free, premiumMonthly, premiumYearly];
}
