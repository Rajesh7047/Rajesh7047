enum HealthGoal {
  weightLoss,
  weightGain,
  pcodThyroid,
}

extension HealthGoalLabel on HealthGoal {
  String get label {
    switch (this) {
      case HealthGoal.weightLoss:
        return 'Weight Loss';
      case HealthGoal.weightGain:
        return 'Weight Gain';
      case HealthGoal.pcodThyroid:
        return 'PCOD / Thyroid';
    }
  }
}
