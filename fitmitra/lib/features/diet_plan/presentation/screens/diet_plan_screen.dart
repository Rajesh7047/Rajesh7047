import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../data/models/diet_plan_model.dart';

final selectedGoalProvider = StateProvider<String>((ref) => 'Weight Loss');

class DietPlanScreen extends ConsumerWidget {
  const DietPlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGoal = ref.watch(selectedGoalProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final plan = _getDietPlan(selectedGoal);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Diet Plans'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose your goal',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
            ).animate().fadeIn(),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['Weight Loss', 'Weight Gain', 'PCOD/Thyroid', 'Muscle Building'].map((goal) {
                  final isSelected = selectedGoal == goal;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(goal),
                      selected: isSelected,
                      onSelected: (_) => ref.read(selectedGoalProvider.notifier).state = goal,
                      selectedColor: AppColors.primary.withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.primary : null,
                        fontWeight: isSelected ? FontWeight.w600 : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ).animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 20),

            CustomCard(
              gradient: AppColors.primaryGradient,
              animationIndex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plan.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(plan.description, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${plan.totalCalories} kcal/day',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            SectionHeader(title: 'Daily Meals', icon: Icons.restaurant_rounded),
            ...plan.meals.asMap().entries.map((entry) {
              final meal = entry.value;
              final index = entry.key;
              return CustomCard(
                animationIndex: index + 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _getMealColor(meal.type).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(_getMealIcon(meal.type), color: _getMealColor(meal.type), size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(meal.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                              Text(meal.time, style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${meal.calories} kcal',
                            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...meal.items.map((item) => Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 4),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle_rounded, color: AppColors.success, size: 16),
                              const SizedBox(width: 8),
                              Expanded(child: Text(item, style: Theme.of(context).textTheme.bodyMedium)),
                            ],
                          ),
                        )),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Color _getMealColor(String type) {
    switch (type) {
      case 'breakfast': return const Color(0xFFFF9F43);
      case 'morning_snack': return const Color(0xFF45B7D1);
      case 'lunch': return const Color(0xFF4CAF50);
      case 'evening_snack': return const Color(0xFFFF6B6B);
      case 'dinner': return const Color(0xFF6C5CE7);
      default: return AppColors.primary;
    }
  }

  IconData _getMealIcon(String type) {
    switch (type) {
      case 'breakfast': return Icons.wb_sunny_rounded;
      case 'morning_snack': return Icons.coffee_rounded;
      case 'lunch': return Icons.restaurant_rounded;
      case 'evening_snack': return Icons.local_cafe_rounded;
      case 'dinner': return Icons.nightlight_round;
      default: return Icons.restaurant_rounded;
    }
  }

  DietPlanModel _getDietPlan(String goal) {
    switch (goal) {
      case 'Weight Loss':
        return DietPlanModel(
          id: '1',
          name: 'Weight Loss Plan',
          goal: 'Weight Loss',
          description: 'Low-calorie, high-protein Indian diet for sustainable weight loss',
          totalCalories: 1500,
          meals: [
            MealItem(name: 'Breakfast', time: '7:00 - 8:00 AM', description: 'Energy boost', calories: 300, type: 'breakfast', items: ['2 Moong Dal Chilla with mint chutney', '1 cup green tea', '5-6 almonds (soaked)']),
            MealItem(name: 'Mid-Morning', time: '10:00 - 10:30 AM', description: 'Light snack', calories: 100, type: 'morning_snack', items: ['1 apple or guava', '1 cup buttermilk']),
            MealItem(name: 'Lunch', time: '12:30 - 1:30 PM', description: 'Balanced meal', calories: 450, type: 'lunch', items: ['2 multigrain roti', '1 bowl dal / rajma', '1 bowl mixed vegetable sabzi', 'Cucumber-tomato salad', '1 small bowl curd']),
            MealItem(name: 'Evening Snack', time: '4:00 - 4:30 PM', description: 'Pre-workout', calories: 150, type: 'evening_snack', items: ['1 cup roasted makhana', 'Green tea / black coffee']),
            MealItem(name: 'Dinner', time: '7:00 - 8:00 PM', description: 'Light dinner', calories: 400, type: 'dinner', items: ['1 bowl vegetable soup', '1 roti with palak paneer', 'Steamed broccoli / salad']),
          ],
        );
      case 'Weight Gain':
        return DietPlanModel(
          id: '2',
          name: 'Weight Gain Plan',
          goal: 'Weight Gain',
          description: 'High-calorie, nutrient-dense meals for healthy weight gain',
          totalCalories: 2800,
          meals: [
            MealItem(name: 'Breakfast', time: '7:00 - 8:00 AM', description: 'Heavy start', calories: 600, type: 'breakfast', items: ['3 Parathas with butter & curd', '1 glass banana shake with milk', '4-5 dates + mixed nuts']),
            MealItem(name: 'Mid-Morning', time: '10:00 AM', description: 'Protein boost', calories: 300, type: 'morning_snack', items: ['Peanut butter toast (2 slices)', '1 banana', '1 glass full-cream milk']),
            MealItem(name: 'Lunch', time: '1:00 PM', description: 'Heavy lunch', calories: 800, type: 'lunch', items: ['3-4 chapatis with ghee', 'Chicken curry / Paneer butter masala', 'Rice (1 bowl)', 'Dal fry', 'Salad with olive oil dressing']),
            MealItem(name: 'Evening Snack', time: '4:30 PM', description: 'Energy boost', calories: 350, type: 'evening_snack', items: ['Sprouts chaat with peanuts', 'Sweet lassi', '1 handful trail mix']),
            MealItem(name: 'Dinner', time: '8:00 PM', description: 'Balanced dinner', calories: 650, type: 'dinner', items: ['2-3 rotis with ghee', 'Egg curry / Soya chunks curry', 'Vegetable pulao', '1 glass warm milk with turmeric']),
          ],
        );
      case 'PCOD/Thyroid':
        return DietPlanModel(
          id: '3',
          name: 'PCOD/Thyroid Plan',
          goal: 'PCOD/Thyroid',
          description: 'Anti-inflammatory diet plan for hormonal balance',
          totalCalories: 1600,
          isPremium: true,
          meals: [
            MealItem(name: 'Breakfast', time: '7:00 AM', description: 'Anti-inflammatory', calories: 350, type: 'breakfast', items: ['Ragi dosa with coconut chutney', 'Turmeric water (warm)', 'Flax seeds (1 tbsp)']),
            MealItem(name: 'Mid-Morning', time: '10:00 AM', description: 'Antioxidant boost', calories: 100, type: 'morning_snack', items: ['1 cup berries / pomegranate', 'Herbal tea (spearmint for PCOD)']),
            MealItem(name: 'Lunch', time: '1:00 PM', description: 'Balanced', calories: 450, type: 'lunch', items: ['Brown rice / quinoa (1 cup)', 'Methi dal', 'Bottle gourd / ridge gourd sabzi', 'Curd with chia seeds']),
            MealItem(name: 'Evening', time: '4:00 PM', description: 'Light snack', calories: 150, type: 'evening_snack', items: ['Walnuts (4-5) + pumpkin seeds', 'Cinnamon tea']),
            MealItem(name: 'Dinner', time: '7:00 PM', description: 'Easy to digest', calories: 400, type: 'dinner', items: ['Bajra roti (2)', 'Fish curry / Tofu stir-fry', 'Steamed vegetables', 'Turmeric milk before bed']),
          ],
        );
      default:
        return DietPlanModel(
          id: '4',
          name: 'Muscle Building Plan',
          goal: 'Muscle Building',
          description: 'High-protein plan for lean muscle growth',
          totalCalories: 2500,
          isPremium: true,
          meals: [
            MealItem(name: 'Breakfast', time: '7:00 AM', description: 'Protein start', calories: 550, type: 'breakfast', items: ['Egg white omelette (4 eggs)', '2 whole wheat bread with peanut butter', '1 banana', '1 glass milk']),
            MealItem(name: 'Mid-Morning', time: '10:00 AM', description: 'Protein shake', calories: 250, type: 'morning_snack', items: ['Protein shake / Paneer cubes', 'Mixed nuts (20g)']),
            MealItem(name: 'Lunch', time: '1:00 PM', description: 'Heavy meal', calories: 700, type: 'lunch', items: ['Brown rice (1.5 cups)', 'Grilled chicken / Soya chunks', 'Dal tadka', 'Green salad', 'Curd']),
            MealItem(name: 'Pre-Workout', time: '4:00 PM', description: 'Energy', calories: 200, type: 'evening_snack', items: ['1 banana + coffee', 'Peanut butter toast']),
            MealItem(name: 'Dinner', time: '8:00 PM', description: 'Recovery', calories: 600, type: 'dinner', items: ['3 Chapatis', 'Fish / Paneer tikka', 'Mixed veg', 'Warm milk with ashwagandha']),
          ],
        );
    }
  }
}
