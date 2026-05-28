import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitmitra/core/providers/auth_state_provider.dart';
import 'package:fitmitra/core/utils/result.dart';
import 'package:fitmitra/core/providers/repository_providers.dart';
import 'package:fitmitra/domain/entities/diet_plan.dart';
import 'package:fitmitra/shared/widgets/fit_card.dart';
import 'package:fitmitra/shared/widgets/premium_badge.dart';

final dietPlansProvider = FutureProvider.autoDispose<List<DietPlan>>((ref) async {
  final user = ref.watch(currentUserProvider);
  final result = await ref
      .read(contentRepositoryProvider)
      .getDietPlans(goalId: user?.healthGoalId);
  return result.when(success: (l) => l, error: (_) => []);
});

class DietPlansPage extends ConsumerWidget {
  const DietPlansPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final plansAsync = ref.watch(dietPlansProvider);
    final isPremium = user?.hasActivePremium ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text('Diet Plans')),
      body: plansAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Failed to load plans')),
        data: (plans) {
          if (!isPremium) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const PremiumBadge(),
                    const SizedBox(height: 16),
                    const Text(
                      'Personalized diet plans are a Premium feature.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => context.push('/membership'),
                      child: const Text('Upgrade Now'),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: plans.length,
            itemBuilder: (context, index) {
              final plan = plans[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: FitCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (plan.summary != null) Text(plan.summary!),
                      Text('${plan.totalCalories} kcal / day'),
                      const Divider(),
                      ...plan.meals.map(
                        (m) => ListTile(
                          title: Text(m.name),
                          subtitle: Text(m.items.join(', ')),
                          trailing: Text('${m.calories} kcal'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
