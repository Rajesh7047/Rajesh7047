import 'package:fitmitra/shared/models/health_goal.dart';

class DietPlan {
  const DietPlan({
    required this.goal,
    required this.title,
    required this.meals,
  });

  final HealthGoal goal;
  final String title;
  final List<String> meals;
}
