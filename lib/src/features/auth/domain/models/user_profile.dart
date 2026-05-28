import 'package:fitmitra/src/core/constants/app_constants.dart';
import 'package:fitmitra/src/core/models/membership_tier.dart';
import 'package:fitmitra/src/core/models/wellness_goal.dart';

class UserProfile {
  const UserProfile({
    required this.id,
    required this.phoneNumber,
    required this.displayName,
    required this.goal,
    required this.membershipTier,
    required this.dailyCalorieTarget,
    required this.dailyWaterTargetMl,
    required this.streak,
  });

  final String id;
  final String phoneNumber;
  final String displayName;
  final WellnessGoal goal;
  final MembershipTier membershipTier;
  final int dailyCalorieTarget;
  final int dailyWaterTargetMl;
  final int streak;

  bool get isPremium => membershipTier == MembershipTier.premium;

  UserProfile copyWith({
    String? id,
    String? phoneNumber,
    String? displayName,
    WellnessGoal? goal,
    MembershipTier? membershipTier,
    int? dailyCalorieTarget,
    int? dailyWaterTargetMl,
    int? streak,
  }) {
    return UserProfile(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      displayName: displayName ?? this.displayName,
      goal: goal ?? this.goal,
      membershipTier: membershipTier ?? this.membershipTier,
      dailyCalorieTarget: dailyCalorieTarget ?? this.dailyCalorieTarget,
      dailyWaterTargetMl: dailyWaterTargetMl ?? this.dailyWaterTargetMl,
      streak: streak ?? this.streak,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'displayName': displayName,
      'goal': goal.name,
      'membershipTier': membershipTier.name,
      'dailyCalorieTarget': dailyCalorieTarget,
      'dailyWaterTargetMl': dailyWaterTargetMl,
      'streak': streak,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      displayName: json['displayName'] as String? ?? 'FitMitra Member',
      goal: wellnessGoalFromKey(json['goal'] as String? ?? ''),
      membershipTier: membershipTierFromKey(
        json['membershipTier'] as String? ?? '',
      ),
      dailyCalorieTarget:
          json['dailyCalorieTarget'] as int? ?? AppConstants.defaultCalorieGoal,
      dailyWaterTargetMl:
          json['dailyWaterTargetMl'] as int? ?? AppConstants.defaultWaterGoalMl,
      streak: json['streak'] as int? ?? 4,
    );
  }
}
