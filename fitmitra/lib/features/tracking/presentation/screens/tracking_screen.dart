import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/section_header.dart';
import '../../data/models/tracking_model.dart';

final trackingProvider = StateNotifierProvider<TrackingNotifier, DailyTracking>((ref) {
  return TrackingNotifier();
});

class TrackingNotifier extends StateNotifier<DailyTracking> {
  TrackingNotifier()
      : super(DailyTracking(
          id: 'today',
          userId: 'current',
          date: DateTime.now(),
          waterIntakeMl: 1500,
          caloriesConsumed: 1200,
          exerciseMinutes: 20,
          meals: [
            MealLog(name: 'Oats Upma', calories: 220, mealType: 'Breakfast'),
            MealLog(name: 'Green Tea', calories: 5, mealType: 'Breakfast'),
            MealLog(name: 'Apple', calories: 95, mealType: 'Snack'),
            MealLog(name: 'Dal Rice + Sabzi', calories: 480, mealType: 'Lunch'),
            MealLog(name: 'Makhana', calories: 120, mealType: 'Snack'),
          ],
        ));

  void addWater(double ml) {
    state = DailyTracking(
      id: state.id,
      userId: state.userId,
      date: state.date,
      waterIntakeMl: state.waterIntakeMl + ml,
      waterGoalMl: state.waterGoalMl,
      caloriesConsumed: state.caloriesConsumed,
      calorieGoal: state.calorieGoal,
      exerciseMinutes: state.exerciseMinutes,
      exerciseGoal: state.exerciseGoal,
      meals: state.meals,
    );
  }

  void addMeal(MealLog meal) {
    state = DailyTracking(
      id: state.id,
      userId: state.userId,
      date: state.date,
      waterIntakeMl: state.waterIntakeMl,
      waterGoalMl: state.waterGoalMl,
      caloriesConsumed: state.caloriesConsumed + meal.calories,
      calorieGoal: state.calorieGoal,
      exerciseMinutes: state.exerciseMinutes,
      exerciseGoal: state.exerciseGoal,
      meals: [...state.meals, meal],
    );
  }

  void addExercise(int minutes) {
    state = DailyTracking(
      id: state.id,
      userId: state.userId,
      date: state.date,
      waterIntakeMl: state.waterIntakeMl,
      waterGoalMl: state.waterGoalMl,
      caloriesConsumed: state.caloriesConsumed,
      calorieGoal: state.calorieGoal,
      exerciseMinutes: state.exerciseMinutes + minutes,
      exerciseGoal: state.exerciseGoal,
      meals: state.meals,
    );
  }
}

class TrackingScreen extends ConsumerWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracking = ref.watch(trackingProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Daily Tracking'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Overview
            Row(
              children: [
                Expanded(child: _buildCircularTracker(context, 'Calories', tracking.caloriesConsumed, tracking.calorieGoal, tracking.caloriePercent, AppColors.accent, Icons.local_fire_department_rounded, 'kcal')),
                const SizedBox(width: 12),
                Expanded(child: _buildCircularTracker(context, 'Water', tracking.waterIntakeMl.round(), tracking.waterGoalMl.round(), tracking.waterPercent, AppColors.secondary, Icons.water_drop_rounded, 'ml')),
                const SizedBox(width: 12),
                Expanded(child: _buildCircularTracker(context, 'Exercise', tracking.exerciseMinutes, tracking.exerciseGoal, tracking.exercisePercent, AppColors.success, Icons.directions_run_rounded, 'min')),
              ],
            ).animate().fadeIn(duration: 500.ms),
            const SizedBox(height: 24),

            // Water Tracking
            SectionHeader(title: 'Water Intake', icon: Icons.water_drop_rounded),
            CustomCard(
              animationIndex: 1,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${tracking.waterIntakeMl.round()} ml', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.secondary, fontWeight: FontWeight.w700)),
                          Text('of ${tracking.waterGoalMl.round()} ml goal', style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                      Text('${tracking.glassesOfWater} glasses', style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearPercentIndicator(
                    padding: EdgeInsets.zero,
                    lineHeight: 12,
                    percent: tracking.waterPercent,
                    backgroundColor: AppColors.secondary.withOpacity(0.15),
                    progressColor: AppColors.secondary,
                    barRadius: const Radius.circular(6),
                    animation: true,
                    animationDuration: 800,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => ref.read(trackingProvider.notifier).addWater(250),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('+250ml'),
                          style: OutlinedButton.styleFrom(foregroundColor: AppColors.secondary, side: BorderSide(color: AppColors.secondary.withOpacity(0.5))),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => ref.read(trackingProvider.notifier).addWater(500),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('+500ml'),
                          style: OutlinedButton.styleFrom(foregroundColor: AppColors.secondary, side: BorderSide(color: AppColors.secondary.withOpacity(0.5))),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Calorie Tracking
            SectionHeader(title: 'Calorie Log', icon: Icons.restaurant_rounded),
            CustomCard(
              animationIndex: 2,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${tracking.caloriesConsumed} kcal', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.accent, fontWeight: FontWeight.w700)),
                          Text('of ${tracking.calorieGoal} kcal goal', style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                      Text('${tracking.calorieGoal - tracking.caloriesConsumed} remaining', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearPercentIndicator(
                    padding: EdgeInsets.zero,
                    lineHeight: 12,
                    percent: tracking.caloriePercent,
                    backgroundColor: AppColors.accent.withOpacity(0.15),
                    progressColor: AppColors.accent,
                    barRadius: const Radius.circular(6),
                    animation: true,
                    animationDuration: 800,
                  ),
                  const SizedBox(height: 16),
                  ...tracking.meals.map((meal) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(_getMealIcon(meal.mealType), size: 16, color: AppColors.accent),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(meal.name, style: Theme.of(context).textTheme.titleSmall),
                                  Text(meal.mealType, style: Theme.of(context).textTheme.bodySmall),
                                ],
                              ),
                            ),
                            Text('${meal.calories} kcal', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.accent, fontSize: 13)),
                          ],
                        ),
                      )),
                  const SizedBox(height: 8),
                  CustomButton(
                    text: 'Add Meal',
                    icon: Icons.add_rounded,
                    onPressed: () => _showAddMealDialog(context, ref),
                    isOutlined: true,
                    height: 44,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Exercise
            SectionHeader(title: 'Exercise', icon: Icons.directions_run_rounded),
            CustomCard(
              animationIndex: 3,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${tracking.exerciseMinutes} min', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.success, fontWeight: FontWeight.w700)),
                          Text('of ${tracking.exerciseGoal} min goal', style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearPercentIndicator(
                    padding: EdgeInsets.zero,
                    lineHeight: 12,
                    percent: tracking.exercisePercent,
                    backgroundColor: AppColors.success.withOpacity(0.15),
                    progressColor: AppColors.success,
                    barRadius: const Radius.circular(6),
                    animation: true,
                    animationDuration: 800,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [10, 15, 30, 45].map((min) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: OutlinedButton(
                            onPressed: () => ref.read(trackingProvider.notifier).addExercise(min),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.success,
                              side: BorderSide(color: AppColors.success.withOpacity(0.5)),
                              padding: EdgeInsets.zero,
                            ),
                            child: Text('+${min}m', style: const TextStyle(fontSize: 12)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularTracker(BuildContext context, String label, int current, int goal, double percent, Color color, IconData icon, String unit) {
    return CustomCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          CircularPercentIndicator(
            radius: 36,
            lineWidth: 5,
            percent: percent,
            center: Icon(icon, color: color, size: 22),
            progressColor: color,
            backgroundColor: color.withOpacity(0.15),
            circularStrokeCap: CircularStrokeCap.round,
            animation: true,
            animationDuration: 1000,
          ),
          const SizedBox(height: 8),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
          Text('$current', style: TextStyle(fontWeight: FontWeight.w700, color: color, fontSize: 16)),
          Text(unit, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10)),
        ],
      ),
    );
  }

  IconData _getMealIcon(String type) {
    switch (type) {
      case 'Breakfast': return Icons.wb_sunny_rounded;
      case 'Lunch': return Icons.restaurant_rounded;
      case 'Dinner': return Icons.nightlight_round;
      case 'Snack': return Icons.local_cafe_rounded;
      default: return Icons.restaurant;
    }
  }

  void _showAddMealDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final calController = TextEditingController();
    String mealType = 'Snack';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Meal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Food Name')),
            const SizedBox(height: 12),
            TextField(controller: calController, decoration: const InputDecoration(labelText: 'Calories (kcal)'), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: mealType,
              decoration: const InputDecoration(labelText: 'Meal Type'),
              items: ['Breakfast', 'Lunch', 'Dinner', 'Snack'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (v) => mealType = v!,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final cal = int.tryParse(calController.text) ?? 0;
              if (name.isNotEmpty && cal > 0) {
                ref.read(trackingProvider.notifier).addMeal(MealLog(name: name, calories: cal, mealType: mealType));
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
