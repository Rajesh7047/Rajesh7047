import 'package:fitmitra/features/diet/domain/diet_plan.dart';
import 'package:fitmitra/shared/models/health_goal.dart';
import 'package:flutter/material.dart';

class DietPlanScreen extends StatelessWidget {
  const DietPlanScreen({super.key});

  static const plans = [
    DietPlan(
      goal: HealthGoal.weightLoss,
      title: 'Fat Loss Metabolic Reset',
      meals: ['Jeera water + soaked almonds', 'Millet bowl + paneer', 'Grilled tofu + salad'],
    ),
    DietPlan(
      goal: HealthGoal.weightGain,
      title: 'Lean Muscle Gain',
      meals: ['Banana shake + oats', 'Rice + dal + ghee + curd', 'Peanut chikki + yogurt'],
    ),
    DietPlan(
      goal: HealthGoal.pcodThyroid,
      title: 'Hormonal Balance Plate',
      meals: ['Flaxseed water + eggs', 'Quinoa khichdi + veggies', 'Moong chilla + mint dip'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final plan = plans[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plan.goal.label, style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 6),
                Text(plan.title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                ...plan.meals.map((meal) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text('• $meal'),
                    )),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: plans.length,
    );
  }
}
