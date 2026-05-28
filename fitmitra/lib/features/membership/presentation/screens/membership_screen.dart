import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/gradient_container.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class MembershipScreen extends ConsumerStatefulWidget {
  const MembershipScreen({super.key});

  @override
  ConsumerState<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends ConsumerState<MembershipScreen> {
  String _selectedPlan = 'annual';

  final _plans = [
    _PlanData(
      id: 'monthly',
      title: 'Monthly',
      price: 499,
      period: '/month',
      badge: null,
      savings: null,
    ),
    _PlanData(
      id: 'quarterly',
      title: 'Quarterly',
      price: 1299,
      period: '/3 months',
      badge: 'Popular',
      savings: 'Save ₹198',
    ),
    _PlanData(
      id: 'annual',
      title: 'Annual',
      price: 3999,
      period: '/year',
      badge: 'Best Value',
      savings: 'Save ₹1,989',
    ),
  ];

  void _subscribe() {
    final plan = _plans.firstWhere((p) => p.id == _selectedPlan);
    _openRazorpay(plan.price.toDouble());
  }

  void _openRazorpay(double amount) {
    // Razorpay integration
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('💳', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              'Razorpay Payment',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Amount: ₹${amount.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.primary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Configure your Razorpay API key in AppConstants.razorpayKeyId to enable payments.',
              style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccess();
            },
            child: const Text('Proceed'),
          ),
        ],
      ),
    );
  }

  void _showSuccess() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 12),
            Text('Premium Activated!', style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text('Welcome to FitMitra Premium! Enjoy unlimited access to all features.', style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Start Exploring'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final isPremium = userAsync.valueOrNull?.isPremium ?? false;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Premium Membership')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isPremium)
              _PremiumActiveCard()
            else ...[
              _HeroBanner(),
              const SizedBox(height: 24),
              Text('Choose Your Plan', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text('Cancel anytime. No hidden charges.', style: theme.textTheme.bodySmall),
              const SizedBox(height: 16),
              ..._plans.map((plan) => _PlanCard(
                    plan: plan,
                    isSelected: _selectedPlan == plan.id,
                    onSelect: () => setState(() => _selectedPlan = plan.id),
                  )),
              const SizedBox(height: 24),
              _FeaturesComparison(),
              const SizedBox(height: 24),
              AppButton(
                text: 'Subscribe Now • ₹${_plans.firstWhere((p) => p.id == _selectedPlan).price}',
                onPressed: _subscribe,
                gradient: AppColors.premiumGradient,
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  '🔒 Secured by Razorpay • 100% Safe',
                  style: theme.textTheme.bodySmall,
                ),
              ),
              const SizedBox(height: 24),
              _TestimonialsSection(),
            ],
          ],
        ),
      ),
    );
  }
}

class _PlanData {
  final String id;
  final String title;
  final int price;
  final String period;
  final String? badge;
  final String? savings;

  const _PlanData({
    required this.id,
    required this.title,
    required this.price,
    required this.period,
    this.badge,
    this.savings,
  });
}

class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      gradient: AppColors.premiumGradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 28),
              SizedBox(width: 8),
              Text(
                'FitMitra Premium',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700, fontFamily: 'Poppins'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Unlock your full potential with unlimited access to AI coaching, live mentor sessions, advanced diet plans & more.',
            style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5, fontFamily: 'Poppins'),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              '🤖 AI Chat', '👨‍⚕️ Live Mentors', '🎬 All Videos',
              '📊 Advanced Analytics', '🥗 Custom Meal Plans',
            ].map((f) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(f, style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'Poppins')),
                )).toList(),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final _PlanData plan;
  final bool isSelected;
  final VoidCallback onSelect;

  const _PlanCard({required this.plan, required this.isSelected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFFDE7) : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFFFFAB00) : theme.colorScheme.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: const Color(0xFFFFAB00).withValues(alpha: 0.2), blurRadius: 12, offset: const Offset(0, 4))]
              : [],
        ),
        child: Row(
          children: [
            // Radio
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFFFFAB00) : theme.colorScheme.outlineVariant,
                  width: 2,
                ),
                color: isSelected ? const Color(0xFFFFAB00) : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plan.title, style: theme.textTheme.titleMedium),
                  if (plan.savings != null)
                    Text(plan.savings!, style: const TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.w500, fontFamily: 'Poppins')),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${plan.price}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, fontFamily: 'Poppins', color: Color(0xFFFFAB00)),
                ),
                Text(plan.period, style: theme.textTheme.bodySmall),
              ],
            ),
            if (plan.badge != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: plan.badge == 'Best Value' ? AppColors.premiumGradient : AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  plan.badge!,
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700, fontFamily: 'Poppins'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FeaturesComparison extends StatelessWidget {
  const _FeaturesComparison();

  @override
  Widget build(BuildContext context) {
    final features = [
      ('AI Health Chat', false, true),
      ('Basic Diet Plan', true, true),
      ('Custom Meal Plans', false, true),
      ('Yoga Videos (Basic)', true, true),
      ('All Premium Videos', false, true),
      ('Live Mentor Sessions', false, true),
      ('Calorie & Water Tracking', true, true),
      ('Advanced Analytics', false, true),
      ('Product Recommendations', false, true),
      ('Priority Support', false, true),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('What You Get', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: const Row(
                  children: [
                    Expanded(child: Text('Feature', style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Poppins', fontSize: 13))),
                    SizedBox(width: 60, child: Text('Free', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Poppins', fontSize: 13))),
                    SizedBox(width: 70, child: Text('Premium', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Poppins', fontSize: 13, color: Color(0xFFFFAB00)))),
                  ],
                ),
              ),
              ...features.asMap().entries.map((entry) {
                final f = entry.value;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    border: entry.key < features.length - 1
                        ? Border(bottom: BorderSide(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5)))
                        : null,
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text(f.$1, style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'))),
                      SizedBox(
                        width: 60,
                        child: Icon(
                          f.$2 ? Icons.check_circle_rounded : Icons.cancel_rounded,
                          color: f.$2 ? AppColors.success : Colors.grey[300],
                          size: 18,
                        ),
                      ),
                      SizedBox(
                        width: 70,
                        child: Icon(
                          f.$3 ? Icons.check_circle_rounded : Icons.cancel_rounded,
                          color: f.$3 ? const Color(0xFFFFAB00) : Colors.grey[300],
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class _TestimonialsSection extends StatelessWidget {
  const _TestimonialsSection();

  @override
  Widget build(BuildContext context) {
    final testimonials = [
      ('👩', 'Priya K.', 'Lost 8kg in 3 months! The AI meal plans are amazing 🎉'),
      ('👨', 'Rahul M.', 'Live mentor sessions transformed my fitness journey completely!'),
      ('👩', 'Anjali S.', 'PCOD yoga videos helped me manage symptoms naturally. Love it!'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('What Members Say', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        ...testimonials.map((t) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(t.$1, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 8),
                      Text(t.$2, style: const TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                      const Spacer(),
                      const Row(
                        children: [
                          Icon(Icons.star_rounded, color: Color(0xFFFFAB00), size: 16),
                          Icon(Icons.star_rounded, color: Color(0xFFFFAB00), size: 16),
                          Icon(Icons.star_rounded, color: Color(0xFFFFAB00), size: 16),
                          Icon(Icons.star_rounded, color: Color(0xFFFFAB00), size: 16),
                          Icon(Icons.star_rounded, color: Color(0xFFFFAB00), size: 16),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(t.$3, style: const TextStyle(fontSize: 13, height: 1.5, fontFamily: 'Poppins', color: AppColors.textSecondary)),
                ],
              ),
            )),
      ],
    );
  }
}

class _PremiumActiveCard extends StatelessWidget {
  const _PremiumActiveCard();

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      gradient: AppColors.premiumGradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 32),
              SizedBox(width: 8),
              Text('Premium Active', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
            ],
          ),
          const SizedBox(height: 8),
          const Text('You have full access to all FitMitra premium features!', style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Poppins')),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('Valid until: December 31, 2026', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
          ),
        ],
      ),
    );
  }
}
