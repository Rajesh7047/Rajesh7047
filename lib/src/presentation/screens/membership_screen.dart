import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/app_providers.dart';
import '../widgets/fitmitra_widgets.dart';

class MembershipScreen extends ConsumerWidget {
  const MembershipScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final tier = ref.watch(activeMembershipProvider);
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(pinned: true, title: const Text('Membership')),
        SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: SliverList.list(
            children: <Widget>[
              GradientCard(
                colors: const <Color>[Color(0xFF111827), Color(0xFF0B6E4F)],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const PremiumBadge(),
                    const SizedBox(height: 18),
                    Text(
                      tier.isPremium ? 'Premium is active' : 'Unlock FitMitra Premium',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Get advanced AI plans, premium yoga and recipe videos, live mentor sessions, and goal-specific product recommendations.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _PlanCard(
                title: 'Free',
                price: 'INR 0',
                features: const <String>[
                  'Mobile OTP login',
                  'Basic AI wellness chat',
                  'Starter diet plan',
                  'Calorie and water tracking',
                ],
                selected: !tier.isPremium,
              ),
              const SizedBox(height: 16),
              _PlanCard(
                title: 'Premium',
                price: 'INR 499 / month',
                features: const <String>[
                  'Personalized AI diet plans',
                  'Premium yoga, meditation, and recipe videos',
                  'Live Zoom mentor sessions',
                  'Razorpay-backed membership activation',
                  'Goal-based product recommendations',
                ],
                selected: tier.isPremium,
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: tier.isPremium
                    ? null
                    : () async {
                        final result = await ref.read(paymentRepositoryProvider).startPremiumCheckout(
                              uid: user?.uid ?? 'guest',
                              phoneNumber: user?.phoneNumber ?? '',
                              amountInPaise: 49900,
                            );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.message)));
                        }
                      },
                icon: const Icon(Icons.payments_rounded),
                label: Text(tier.isPremium ? 'Premium active' : 'Upgrade with Razorpay'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.title, required this.price, required this.features, required this.selected});

  final String title;
  final String price;
  final List<String> features;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900))),
                if (selected) const Icon(Icons.check_circle_rounded),
              ],
            ),
            const SizedBox(height: 8),
            Text(price, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            ...features.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.check_rounded, size: 18),
                      const SizedBox(width: 8),
                      Expanded(child: Text(feature)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
