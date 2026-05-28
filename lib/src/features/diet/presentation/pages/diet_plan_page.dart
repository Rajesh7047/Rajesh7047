import 'package:fitmitra/src/core/models/wellness_goal.dart';
import 'package:fitmitra/src/core/widgets/app_card.dart';
import 'package:fitmitra/src/core/widgets/metric_tile.dart';
import 'package:fitmitra/src/core/widgets/section_header.dart';
import 'package:fitmitra/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:fitmitra/src/features/diet/data/repositories/diet_repository.dart';
import 'package:fitmitra/src/features/diet/domain/models/diet_plan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dietPlanProvider = FutureProvider<DietPlan>((ref) {
  final user = ref.watch(authControllerProvider).user;
  return ref
      .watch(dietRepositoryProvider)
      .getPlan(
        goal: user?.goal ?? WellnessGoal.weightLoss,
        isPremium: user?.isPremium ?? false,
      );
});

class DietPlanPage extends ConsumerWidget {
  const DietPlanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(dietPlanProvider);

    return planAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text(error.toString())),
      data: (plan) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.title,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 10),
                    Text(plan.description),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: MediaQuery.sizeOf(context).width > 980 ? 4 : 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.15,
                children: [
                  MetricTile(
                    icon: Icons.local_fire_department_rounded,
                    label: 'Calories',
                    value: '${plan.dailyCalories}',
                    caption: 'Daily target',
                  ),
                  MetricTile(
                    icon: Icons.egg_alt_rounded,
                    label: 'Protein',
                    value: '${plan.proteinGrams} g',
                    caption: 'Muscle & satiety',
                  ),
                  MetricTile(
                    icon: Icons.rice_bowl_rounded,
                    label: 'Carbs',
                    value: '${plan.carbsGrams} g',
                    caption: 'Energy support',
                  ),
                  MetricTile(
                    icon: Icons.opacity_rounded,
                    label: 'Hydration',
                    value: '${plan.hydrationGoalMl} ml',
                    caption: 'Water goal',
                  ),
                ],
              ),
              const SizedBox(height: 28),
              const SectionHeader(
                title: 'Meal timeline',
                subtitle:
                    'A practical day template tailored to your active goal.',
              ),
              const SizedBox(height: 16),
              for (final meal in plan.meals)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppCard(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 92,
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            meal.time,
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                meal.title,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 6),
                              Text(meal.description),
                            ],
                          ),
                        ),
                        Text('${meal.calories} kcal'),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 28),
              const SectionHeader(
                title: 'Coach notes',
                subtitle:
                    'High-leverage behaviors that make the meal plan easier to follow.',
              ),
              const SizedBox(height: 16),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final note in plan.coachNotes)
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
                            Expanded(child: Text(note)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Premium add-ons',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    for (final note in plan.premiumAddOns)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text('• $note'),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
