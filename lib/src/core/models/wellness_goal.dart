import 'package:flutter/material.dart';

enum WellnessGoal { weightLoss, weightGain, pcodThyroid }

extension WellnessGoalX on WellnessGoal {
  String get label => switch (this) {
    WellnessGoal.weightLoss => 'Weight Loss',
    WellnessGoal.weightGain => 'Weight Gain',
    WellnessGoal.pcodThyroid => 'PCOD / Thyroid',
  };

  String get shortLabel => switch (this) {
    WellnessGoal.weightLoss => 'Fat Burn',
    WellnessGoal.weightGain => 'Lean Gain',
    WellnessGoal.pcodThyroid => 'Hormone Balance',
  };

  String get coachPrompt => switch (this) {
    WellnessGoal.weightLoss =>
      'Focus on satiety, movement, and sustainable calorie balance.',
    WellnessGoal.weightGain =>
      'Prioritize recovery, strength, and calorie-dense whole foods.',
    WellnessGoal.pcodThyroid =>
      'Support hormones with stable energy, stress management, and anti-inflammatory routines.',
  };

  IconData get icon => switch (this) {
    WellnessGoal.weightLoss => Icons.local_fire_department_rounded,
    WellnessGoal.weightGain => Icons.fitness_center_rounded,
    WellnessGoal.pcodThyroid => Icons.spa_rounded,
  };

  Color get accentColor => switch (this) {
    WellnessGoal.weightLoss => const Color(0xFFFF7A59),
    WellnessGoal.weightGain => const Color(0xFF5C7CFA),
    WellnessGoal.pcodThyroid => const Color(0xFF2CB67D),
  };
}

WellnessGoal wellnessGoalFromKey(String value) {
  return WellnessGoal.values.firstWhere(
    (goal) => goal.name == value,
    orElse: () => WellnessGoal.weightLoss,
  );
}
