import 'package:equatable/equatable.dart';

class DietMeal extends Equatable {
  const DietMeal({
    required this.name,
    required this.calories,
    required this.items,
    this.time,
  });

  final String name;
  final int calories;
  final List<String> items;
  final String? time;

  @override
  List<Object?> get props => [name, calories];
}

class DietPlan extends Equatable {
  const DietPlan({
    required this.id,
    required this.title,
    required this.goalId,
    required this.meals,
    this.isPremiumOnly = true,
    this.summary,
  });

  final String id;
  final String title;
  final String goalId;
  final List<DietMeal> meals;
  final bool isPremiumOnly;
  final String? summary;

  int get totalCalories =>
      meals.fold(0, (sum, meal) => sum + meal.calories);

  @override
  List<Object?> get props => [id, title, goalId];
}
