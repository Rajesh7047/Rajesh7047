import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitmitra/src/core/config/app_config.dart';
import 'package:fitmitra/src/core/models/wellness_goal.dart';
import 'package:fitmitra/src/features/diet/domain/models/diet_plan.dart';
import 'package:fitmitra/src/shared/data/seed_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitmitra/src/core/providers/core_providers.dart';

final dietRepositoryProvider = Provider<DietRepository>((ref) {
  return DietRepository(ref.watch(firestoreProvider));
});

class DietRepository {
  const DietRepository(this._firestore);

  final FirebaseFirestore? _firestore;

  Future<DietPlan> getPlan({
    required WellnessGoal goal,
    required bool isPremium,
  }) async {
    if (_firestore != null) {
      final document = await _firestore!
          .collection(AppConfig.dietPlansCollection)
          .doc(goal.name)
          .get();
      if (document.exists) {
        final data = document.data();
        if (data != null) {
          final meals = ((data['meals'] as List<dynamic>?) ?? const [])
              .map(
                (meal) => DietMeal(
                  time: meal['time'] as String? ?? '',
                  title: meal['title'] as String? ?? '',
                  description: meal['description'] as String? ?? '',
                  calories: meal['calories'] as int? ?? 0,
                ),
              )
              .toList();

          return DietPlan(
            goal: goal,
            title:
                data['title'] as String? ??
                SeedData.dietPlanFor(goal, isPremium: isPremium).title,
            description: data['description'] as String? ?? '',
            dailyCalories: data['dailyCalories'] as int? ?? 0,
            hydrationGoalMl: data['hydrationGoalMl'] as int? ?? 0,
            proteinGrams: data['proteinGrams'] as int? ?? 0,
            carbsGrams: data['carbsGrams'] as int? ?? 0,
            fatsGrams: data['fatsGrams'] as int? ?? 0,
            meals: meals,
            coachNotes: ((data['coachNotes'] as List<dynamic>?) ?? const [])
                .map((note) => note.toString())
                .toList(),
            premiumAddOns:
                ((data['premiumAddOns'] as List<dynamic>?) ?? const [])
                    .map((note) => note.toString())
                    .toList(),
          );
        }
      }
    }

    return SeedData.dietPlanFor(goal, isPremium: isPremium);
  }
}
