import 'package:fitmitra/src/core/widgets/app_card.dart';
import 'package:fitmitra/src/core/widgets/primary_button.dart';
import 'package:fitmitra/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:fitmitra/src/features/membership/presentation/controllers/membership_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MembershipPage extends ConsumerWidget {
  const MembershipPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plans = ref.watch(membershipPlansProvider);
    final membershipState = ref.watch(membershipControllerProvider);
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Membership plans')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upgrade to premium wellness',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Razorpay checkout is ready for live keys via --dart-define. Until keys are configured, premium upgrades complete in guided demo mode so you can validate the app flow.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                if (membershipState.message != null) ...[
                  const SizedBox(height: 16),
                  Text(membershipState.message!),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          for (final plan in plans)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                plan.title,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(height: 8),
                              Text(plan.subtitle),
                            ],
                          ),
                        ),
                        if (plan.isPopular)
                          Chip(
                            avatar: const Icon(Icons.stars_rounded),
                            label: const Text('Popular'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      plan.priceLabel,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(plan.billingLabel),
                    const SizedBox(height: 16),
                    for (final feature in plan.features)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Icon(Icons.check_circle_rounded, size: 18),
                            ),
                            const SizedBox(width: 10),
                            Expanded(child: Text(feature)),
                          ],
                        ),
                      ),
                    const SizedBox(height: 12),
                    PrimaryButton(
                      label: authState.user == null
                          ? 'Login to continue'
                          : authState.user!.membershipTier == plan.tier &&
                                plan.tier.name == 'premium'
                          ? 'Current active plan'
                          : 'Choose ${plan.title}',
                      isLoading: membershipState.isProcessing,
                      onPressed:
                          authState.user == null || membershipState.isProcessing
                          ? null
                          : () => ref
                                .read(membershipControllerProvider.notifier)
                                .activatePlan(plan),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
