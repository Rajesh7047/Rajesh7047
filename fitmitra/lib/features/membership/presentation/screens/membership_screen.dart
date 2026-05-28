import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/custom_button.dart';

class MembershipScreen extends ConsumerWidget {
  const MembershipScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Premium Membership'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: AppColors.premiumGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: const Color(0xFFFFD700).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8)),
                ],
              ),
              child: const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 44),
            ).animate().scale(duration: 500.ms),
            const SizedBox(height: 16),
            Text('Unlock Premium', style: Theme.of(context).textTheme.displaySmall).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 4),
            Text(
              'Get full access to all features',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
            ).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 24),

            ...premiumFeatures.asMap().entries.map((entry) {
              final feature = entry.value;
              return CustomCard(
                animationIndex: entry.key,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: (feature['color'] as Color).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(feature['icon'] as IconData, color: feature['color'] as Color, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(feature['title'] as String, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                          Text(feature['desc'] as String, style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                    const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 22),
                  ],
                ),
              );
            }),

            const SizedBox(height: 24),
            Text('Choose a Plan', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: CustomCard(
                    animationIndex: 7,
                    padding: const EdgeInsets.all(20),
                    border: Border.all(color: AppColors.dividerLight, width: 1.5),
                    child: Column(
                      children: [
                        const Text('Monthly', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                        const SizedBox(height: 8),
                        Text('₹299', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.primary)),
                        Text('/month', style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: 12),
                        CustomButton(text: 'Subscribe', onPressed: () => _processPayment(context, 299, 'monthly'), height: 42, borderRadius: 10),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomCard(
                    animationIndex: 8,
                    padding: const EdgeInsets.all(20),
                    gradient: AppColors.primaryGradient,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                          child: const Text('BEST VALUE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(height: 8),
                        const Text('Yearly', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white)),
                        const SizedBox(height: 8),
                        const Text('₹2,499', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)),
                        const Text('/year', style: TextStyle(color: Colors.white70)),
                        const SizedBox(height: 4),
                        const Text('Save 30%', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 42,
                          child: ElevatedButton(
                            onPressed: () => _processPayment(context, 2499, 'yearly'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                            child: const Text('Subscribe'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Cancel anytime. Secure payment via Razorpay.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _processPayment(BuildContext context, int amount, String plan) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Payment'),
        content: Text('Razorpay payment of ₹$amount for $plan plan will be initiated.\n\nNote: Configure your Razorpay API keys to enable payments.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Proceed')),
        ],
      ),
    );
  }

  static final List<Map<String, dynamic>> premiumFeatures = [
    {'icon': Icons.smart_toy_rounded, 'title': 'AI Health Chat', 'desc': 'Unlimited AI-powered health consultations', 'color': AppColors.primary},
    {'icon': Icons.restaurant_menu_rounded, 'title': 'Custom Diet Plans', 'desc': 'Personalized meal plans for your goals', 'color': AppColors.success},
    {'icon': Icons.self_improvement_rounded, 'title': 'Premium Yoga Sessions', 'desc': 'Access all yoga & meditation content', 'color': AppColors.accent},
    {'icon': Icons.groups_rounded, 'title': 'Live Mentor Sessions', 'desc': 'Weekly Zoom sessions with health experts', 'color': const Color(0xFF6C5CE7)},
    {'icon': Icons.videocam_rounded, 'title': 'Recipe Videos', 'desc': 'Step-by-step healthy cooking guides', 'color': const Color(0xFF45B7D1)},
    {'icon': Icons.analytics_rounded, 'title': 'Advanced Analytics', 'desc': 'Detailed health tracking & insights', 'color': const Color(0xFFFF9F43)},
  ];
}
