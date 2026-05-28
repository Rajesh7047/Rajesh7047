class DailyTracking {
  final String id;
  final String userId;
  final DateTime date;
  final double waterIntakeMl;
  final double waterGoalMl;
  final int caloriesConsumed;
  final int calorieGoal;
  final int exerciseMinutes;
  final int exerciseGoal;
  final double? weight;
  final String? mood;
  final List<MealLog> meals;

  DailyTracking({
    required this.id,
    required this.userId,
    required this.date,
    this.waterIntakeMl = 0,
    this.waterGoalMl = 3000,
    this.caloriesConsumed = 0,
    this.calorieGoal = 2000,
    this.exerciseMinutes = 0,
    this.exerciseGoal = 30,
    this.weight,
    this.mood,
    this.meals = const [],
  });

  double get waterPercent => waterGoalMl > 0 ? (waterIntakeMl / waterGoalMl).clamp(0.0, 1.0) : 0;
  double get caloriePercent => calorieGoal > 0 ? (caloriesConsumed / calorieGoal).clamp(0.0, 1.0) : 0;
  double get exercisePercent => exerciseGoal > 0 ? (exerciseMinutes / exerciseGoal).clamp(0.0, 1.0) : 0;
  int get glassesOfWater => (waterIntakeMl / 250).round();
}

class MealLog {
  final String name;
  final int calories;
  final String mealType;
  final DateTime time;

  MealLog({
    required this.name,
    required this.calories,
    required this.mealType,
    DateTime? time,
  }) : time = time ?? DateTime.now();
}
