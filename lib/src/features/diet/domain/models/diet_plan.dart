import 'package:fitmitra/src/core/models/wellness_goal.dart';

class DietMeal {
  const DietMeal({
    required this.time,
    required this.title,
    required this.description,
    required this.calories,
  });

  final String time;
  final String title;
  final String description;
  final int calories;
}

class DietPlan {
  const DietPlan({
    required this.goal,
    required this.title,
    required this.description,
    required this.dailyCalories,
    required this.hydrationGoalMl,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatsGrams,
    required this.meals,
    required this.coachNotes,
    required this.premiumAddOns,
  });

  final WellnessGoal goal;
  final String title;
  final String description;
  final int dailyCalories;
  final int hydrationGoalMl;
  final int proteinGrams;
  final int carbsGrams;
  final int fatsGrams;
  final List<DietMeal> meals;
  final List<String> coachNotes;
  final List<String> premiumAddOns;
}
