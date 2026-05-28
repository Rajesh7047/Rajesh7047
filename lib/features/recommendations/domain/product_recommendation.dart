import 'package:fitmitra/shared/models/health_goal.dart';

class ProductRecommendation {
  const ProductRecommendation({
    required this.name,
    required this.goal,
    required this.reason,
  });

  final String name;
  final HealthGoal goal;
  final String reason;
}
