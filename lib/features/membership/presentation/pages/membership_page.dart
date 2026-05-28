import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitmitra/core/constants/membership_plans.dart';
import 'package:fitmitra/core/providers/auth_state_provider.dart';
import 'package:fitmitra/core/providers/repository_providers.dart';
import 'package:fitmitra/core/utils/result.dart';
import 'package:fitmitra/domain/entities/membership_plan.dart';
import 'package:fitmitra/shared/widgets/fit_card.dart';
import 'package:fitmitra/shared/widgets/premium_badge.dart';

class MembershipPage extends ConsumerStatefulWidget {
  const MembershipPage({super.key});

  @override
  ConsumerState<MembershipPage> createState() => _MembershipPageState();
}

class _MembershipPageState extends ConsumerState<MembershipPage> {
  bool _loading = false;

  Future<void> _purchase(MembershipPlan plan) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    setState(() => _loading = true);
    final result = await ref.read(membershipRepositoryProvider).purchasePlan(
          userId: user.uid,
          plan: plan,
        );
    if (!mounted) return;
    setState(() => _loading = false);

    result.when(
      success: (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome to ${plan.name}!')),
        );
        Navigator.of(context).pop();
      },
      error: (f) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(f.message)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final plans =
        MembershipPlans.all.where((p) => p.isPremium).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Membership')),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Center(child: PremiumBadge()),
              const SizedBox(height: 16),
              Text(
                'Unlock your full wellness potential',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              ...plans.map((plan) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: FitCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plan.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            plan.priceDisplay,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          const SizedBox(height: 12),
                          ...plan.features.map(
                            (f) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 18,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(f)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: _loading ? null : () => _purchase(plan),
                            child: Text('Subscribe — ${plan.priceDisplay}'),
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
          if (_loading) const ModalBarrier(dismissible: false),
          if (_loading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
