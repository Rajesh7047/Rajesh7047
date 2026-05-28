import 'package:fitmitra/features/recommendations/domain/product_recommendation.dart';
import 'package:fitmitra/shared/models/health_goal.dart';

class RecommendationEngine {
  List<ProductRecommendation> forGoal(HealthGoal goal) {
    switch (goal) {
      case HealthGoal.weightLoss:
        return const [
          ProductRecommendation(
            name: 'Green Tea Metabolism Support',
            goal: HealthGoal.weightLoss,
            reason: 'Helps improve hydration and mindful snacking replacement.',
          ),
          ProductRecommendation(
            name: 'Smart Portion Meal Box',
            goal: HealthGoal.weightLoss,
            reason: 'Supports calorie-conscious meal planning.',
          ),
        ];
      case HealthGoal.weightGain:
        return const [
          ProductRecommendation(
            name: 'High Protein Whey Isolate',
            goal: HealthGoal.weightGain,
            reason: 'Convenient post-workout protein source for lean gain.',
          ),
          ProductRecommendation(
            name: 'Healthy Calorie Booster Mix',
            goal: HealthGoal.weightGain,
            reason: 'Supports energy surplus with nutrient-rich ingredients.',
          ),
        ];
      case HealthGoal.pcodThyroid:
        return const [
          ProductRecommendation(
            name: 'Omega-3 + Inositol Combo',
            goal: HealthGoal.pcodThyroid,
            reason: 'Often used in hormone-supportive wellness regimens.',
          ),
          ProductRecommendation(
            name: 'Low-GI Seed Snack Kit',
            goal: HealthGoal.pcodThyroid,
            reason: 'Supports blood sugar-friendly snacking habits.',
          ),
        ];
    }
  }
}
