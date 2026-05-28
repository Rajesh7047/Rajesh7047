import 'dart:math';

class AppHelpers {
  AppHelpers._();

  static String getBmiCategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25.0) return 'Normal';
    if (bmi < 30.0) return 'Overweight';
    return 'Obese';
  }

  static String getBmiEmoji(double bmi) {
    if (bmi < 18.5) return '⬇️';
    if (bmi < 25.0) return '✅';
    if (bmi < 30.0) return '⚠️';
    return '🔴';
  }

  static int calculateDailyCalories({
    required double weightKg,
    required double heightCm,
    required int ageYears,
    required String gender,
    required String activityLevel,
    required String goal,
  }) {
    double bmr;
    if (gender.toLowerCase() == 'male') {
      bmr = 88.362 + (13.397 * weightKg) + (4.799 * heightCm) - (5.677 * ageYears);
    } else {
      bmr = 447.593 + (9.247 * weightKg) + (3.098 * heightCm) - (4.330 * ageYears);
    }

    double activityMultiplier = switch (activityLevel) {
      'Sedentary' => 1.2,
      'Lightly Active' => 1.375,
      'Moderately Active' => 1.55,
      'Very Active' => 1.725,
      'Extra Active' => 1.9,
      _ => 1.2,
    };

    double tdee = bmr * activityMultiplier;

    return switch (goal) {
      'Weight Loss' => (tdee - 500).round(),
      'Weight Gain' => (tdee + 300).round(),
      'Muscle Gain' => (tdee + 200).round(),
      _ => tdee.round(),
    };
  }

  static double calculateBmi(double weightKg, double heightCm) {
    final heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }

  static double calculateIdealWeight(double heightCm, String gender) {
    final heightInches = heightCm / 2.54;
    if (gender.toLowerCase() == 'male') {
      return (50 + 2.3 * (heightInches - 60)) * 0.453592;
    } else {
      return (45.5 + 2.3 * (heightInches - 60)) * 0.453592;
    }
  }

  static String generateUniqueId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(20, (_) => chars[random.nextInt(chars.length)]).join();
  }

  static String formatRupees(double amount) {
    final rupees = amount.floor();
    return '₹$rupees';
  }

  static String getGoalColor(String goal) {
    return switch (goal) {
      'Weight Loss' => '#FF5252',
      'Weight Gain' => '#448AFF',
      'PCOD/PCOS' => '#AB47BC',
      'Thyroid Management' => '#AB47BC',
      'Maintenance' => '#00C896',
      'Muscle Gain' => '#FF6B35',
      _ => '#00C896',
    };
  }

  static String getTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }

  static int calculateWaterGoalMl({
    required double weightKg,
    required String activityLevel,
  }) {
    double baseMl = weightKg * 35;
    double extra = switch (activityLevel) {
      'Lightly Active' => 300,
      'Moderately Active' => 500,
      'Very Active' => 700,
      'Extra Active' => 1000,
      _ => 0,
    };
    return (baseMl + extra).round();
  }
}
