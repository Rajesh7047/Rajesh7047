import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';

class MealDetailScreen extends ConsumerWidget {
  final String mealId;

  const MealDetailScreen({super.key, required this.mealId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Details'),
        actions: [
          IconButton(icon: const Icon(Icons.bookmark_outline_rounded), onPressed: () {}),
          IconButton(icon: const Icon(Icons.share_rounded), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              color: AppColors.primaryContainer,
              child: const Center(
                child: Text('🥗', style: TextStyle(fontSize: 100)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Healthy Meal', style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _NutritionChip('380 kcal', Icons.local_fire_department_outlined, AppColors.accent),
                      const SizedBox(width: 10),
                      _NutritionChip('18g Protein', Icons.fitness_center_outlined, Colors.blue),
                      const SizedBox(width: 10),
                      _NutritionChip('52g Carbs', Icons.grain_outlined, Colors.orange),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('Description', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    'This nutritious meal is specially crafted for your health goals. It provides the perfect balance of macronutrients to fuel your body throughout the day.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),
                  Text('Ingredients', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 12),
                  ...[
                    '2 cups mixed salad greens',
                    '1/2 cup cherry tomatoes',
                    '1/4 cup cucumber, sliced',
                    '2 tbsp olive oil',
                    '1 tbsp lemon juice',
                    'Salt and pepper to taste',
                  ].map((ing) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline_rounded, color: AppColors.primary, size: 18),
                        const SizedBox(width: 10),
                        Text(ing, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  )),
                  const SizedBox(height: 24),
                  AppButton(
                    text: 'Log This Meal',
                    onPressed: () => Navigator.pop(context),
                    gradient: AppColors.primaryGradient,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NutritionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _NutritionChip(this.label, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500, fontFamily: 'Poppins')),
        ],
      ),
    );
  }
}
