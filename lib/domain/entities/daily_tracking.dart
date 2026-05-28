import 'package:equatable/equatable.dart';

class DailyTracking extends Equatable {
  const DailyTracking({
    required this.dateKey,
    required this.caloriesConsumed,
    required this.waterMl,
    this.calorieGoal = 2000,
    this.waterGoalMl = 2500,
  });

  final String dateKey;
  final double caloriesConsumed;
  final double waterMl;
  final double calorieGoal;
  final double waterGoalMl;

  double get calorieProgress =>
      calorieGoal > 0 ? (caloriesConsumed / calorieGoal).clamp(0, 1) : 0;

  double get waterProgress =>
      waterGoalMl > 0 ? (waterMl / waterGoalMl).clamp(0, 1) : 0;

  DailyTracking copyWith({
    double? caloriesConsumed,
    double? waterMl,
  }) {
    return DailyTracking(
      dateKey: dateKey,
      caloriesConsumed: caloriesConsumed ?? this.caloriesConsumed,
      waterMl: waterMl ?? this.waterMl,
      calorieGoal: calorieGoal,
      waterGoalMl: waterGoalMl,
    );
  }

  @override
  List<Object?> get props => [dateKey, caloriesConsumed, waterMl];
}
