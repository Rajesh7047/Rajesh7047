class TrackerSummary {
  const TrackerSummary({
    required this.dateKey,
    required this.caloriesConsumed,
    required this.calorieTarget,
    required this.waterMl,
    required this.waterTargetMl,
  });

  final String dateKey;
  final int caloriesConsumed;
  final int calorieTarget;
  final int waterMl;
  final int waterTargetMl;

  double get calorieProgress =>
      calorieTarget == 0 ? 0 : caloriesConsumed / calorieTarget;

  double get waterProgress => waterTargetMl == 0 ? 0 : waterMl / waterTargetMl;

  TrackerSummary copyWith({
    String? dateKey,
    int? caloriesConsumed,
    int? calorieTarget,
    int? waterMl,
    int? waterTargetMl,
  }) {
    return TrackerSummary(
      dateKey: dateKey ?? this.dateKey,
      caloriesConsumed: caloriesConsumed ?? this.caloriesConsumed,
      calorieTarget: calorieTarget ?? this.calorieTarget,
      waterMl: waterMl ?? this.waterMl,
      waterTargetMl: waterTargetMl ?? this.waterTargetMl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dateKey': dateKey,
      'caloriesConsumed': caloriesConsumed,
      'calorieTarget': calorieTarget,
      'waterMl': waterMl,
      'waterTargetMl': waterTargetMl,
    };
  }

  factory TrackerSummary.fromJson(Map<String, dynamic> json) {
    return TrackerSummary(
      dateKey: json['dateKey'] as String? ?? '',
      caloriesConsumed: json['caloriesConsumed'] as int? ?? 0,
      calorieTarget: json['calorieTarget'] as int? ?? 0,
      waterMl: json['waterMl'] as int? ?? 0,
      waterTargetMl: json['waterTargetMl'] as int? ?? 0,
    );
  }
}
