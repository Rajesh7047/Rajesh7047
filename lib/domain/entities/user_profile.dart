import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  const UserProfile({
    required this.uid,
    required this.phoneNumber,
    this.displayName,
    this.email,
    this.healthGoalId,
    this.isPremium = false,
    this.premiumExpiresAt,
    this.dailyCalorieGoal = 2000,
    this.dailyWaterGoalMl = 2500,
    this.createdAt,
  });

  final String uid;
  final String phoneNumber;
  final String? displayName;
  final String? email;
  final String? healthGoalId;
  final bool isPremium;
  final DateTime? premiumExpiresAt;
  final double dailyCalorieGoal;
  final double dailyWaterGoalMl;
  final DateTime? createdAt;

  bool get hasActivePremium {
    if (!isPremium) return false;
    if (premiumExpiresAt == null) return true;
    return premiumExpiresAt!.isAfter(DateTime.now());
  }

  UserProfile copyWith({
    String? displayName,
    String? email,
    String? healthGoalId,
    bool? isPremium,
    DateTime? premiumExpiresAt,
    double? dailyCalorieGoal,
    double? dailyWaterGoalMl,
  }) {
    return UserProfile(
      uid: uid,
      phoneNumber: phoneNumber,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      healthGoalId: healthGoalId ?? this.healthGoalId,
      isPremium: isPremium ?? this.isPremium,
      premiumExpiresAt: premiumExpiresAt ?? this.premiumExpiresAt,
      dailyCalorieGoal: dailyCalorieGoal ?? this.dailyCalorieGoal,
      dailyWaterGoalMl: dailyWaterGoalMl ?? this.dailyWaterGoalMl,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        phoneNumber,
        displayName,
        healthGoalId,
        isPremium,
        premiumExpiresAt,
      ];
}
