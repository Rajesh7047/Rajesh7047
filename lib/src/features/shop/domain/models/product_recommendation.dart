import 'package:fitmitra/src/core/models/wellness_goal.dart';

class ProductRecommendation {
  const ProductRecommendation({
    required this.id,
    required this.goal,
    required this.name,
    required this.description,
    required this.priceLabel,
    required this.rating,
    required this.imageUrl,
    required this.benefits,
    required this.purchaseUrl,
    this.isPremiumPick = false,
  });

  final String id;
  final WellnessGoal goal;
  final String name;
  final String description;
  final String priceLabel;
  final double rating;
  final String imageUrl;
  final List<String> benefits;
  final String purchaseUrl;
  final bool isPremiumPick;
}
