import 'package:fitmitra/domain/entities/health_goal.dart';

/// User health goals for personalized recommendations.
class HealthGoals {
  HealthGoals._();

  static const weightLoss = HealthGoal(
    id: 'weight_loss',
    title: 'Weight Loss',
    description: 'Calorie deficit plans, fat-burn workouts & metabolism support',
    iconName: 'trending_down',
  );

  static const weightGain = HealthGoal(
    id: 'weight_gain',
    title: 'Weight Gain',
    description: 'High-protein diets, strength yoga & mass-gain supplements',
    iconName: 'trending_up',
  );

  static const pcodThyroid = HealthGoal(
    id: 'pcod_thyroid',
    title: 'PCOD / Thyroid',
    description: 'Hormone-friendly meals, gentle yoga & specialist guidance',
    iconName: 'favorite',
  );

  static const generalWellness = HealthGoal(
    id: 'general_wellness',
    title: 'General Wellness',
    description: 'Balanced nutrition, mindfulness & holistic fitness',
    iconName: 'spa',
  );

  static List<HealthGoal> get all =>
      [weightLoss, weightGain, pcodThyroid, generalWellness];

  static HealthGoal? byId(String? id) {
    if (id == null) return null;
    try {
      return all.firstWhere((g) => g.id == id);
    } catch (_) {
      return null;
    }
  }
}
