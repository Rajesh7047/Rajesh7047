import 'package:fitmitra/src/data/demo_seed_data.dart';
import 'package:fitmitra/src/domain/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('health goals expose stable Firestore keys', () {
    expect(HealthGoal.weightLoss.firestoreKey, 'weight_loss');
    expect(HealthGoal.fromKey('pcod_thyroid'), HealthGoal.pcodThyroid);
  });

  test('demo plans are goal specific and have valid targets', () {
    for (final goal in HealthGoal.values) {
      final plan = DemoSeedData.dietPlan(goal);
      expect(plan.goal, goal);
      expect(plan.meals, isNotEmpty);
      expect(plan.calorieTarget, greaterThan(0));
      expect(plan.waterTargetMl, greaterThan(0));
    }
  });

  test('daily tracker progress is clamped', () {
    const state = DailyTrackerState(
      caloriesConsumed: 3000,
      calorieTarget: 1500,
      waterConsumedMl: 500,
      waterTargetMl: 2500,
    );

    expect(state.calorieProgress, 1);
    expect(state.waterProgress, 0.2);
  });
}
