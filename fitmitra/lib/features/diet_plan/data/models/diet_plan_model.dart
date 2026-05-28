class DietPlanModel {
  final String id;
  final String name;
  final String goal;
  final String description;
  final int totalCalories;
  final List<MealItem> meals;
  final bool isPremium;

  DietPlanModel({
    required this.id,
    required this.name,
    required this.goal,
    required this.description,
    required this.totalCalories,
    required this.meals,
    this.isPremium = false,
  });
}

class MealItem {
  final String name;
  final String time;
  final String description;
  final int calories;
  final String type;
  final List<String> items;

  MealItem({
    required this.name,
    required this.time,
    required this.description,
    required this.calories,
    required this.type,
    required this.items,
  });
}
