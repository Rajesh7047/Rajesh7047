import 'package:equatable/equatable.dart';

enum HealthGoal {
  weightLoss,
  weightGain,
  pcodPcos,
  thyroidManagement,
  maintenance,
  muscleGain,
  stressRelief,
}

enum Gender { male, female, other }

enum ActivityLevel { sedentary, lightlyActive, moderatelyActive, veryActive, extraActive }

enum MembershipType { free, monthly, quarterly, annual }

class UserEntity extends Equatable {
  final String uid;
  final String phoneNumber;
  final String? name;
  final String? email;
  final String? photoUrl;
  final int? age;
  final double? heightCm;
  final double? weightKg;
  final String? gender;
  final String? healthGoal;
  final String? activityLevel;
  final String? dietPreference;
  final MembershipType membershipType;
  final DateTime? membershipExpiry;
  final double? bmi;
  final int? dailyCalorieGoal;
  final double? dailyWaterGoalLiters;
  final bool notificationsEnabled;
  final bool profileSetupDone;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserEntity({
    required this.uid,
    required this.phoneNumber,
    this.name,
    this.email,
    this.photoUrl,
    this.age,
    this.heightCm,
    this.weightKg,
    this.gender,
    this.healthGoal,
    this.activityLevel,
    this.dietPreference,
    this.membershipType = MembershipType.free,
    this.membershipExpiry,
    this.bmi,
    this.dailyCalorieGoal,
    this.dailyWaterGoalLiters,
    this.notificationsEnabled = true,
    this.profileSetupDone = false,
    this.createdAt,
    this.updatedAt,
  });

  bool get isPremium =>
      membershipType != MembershipType.free &&
      (membershipExpiry == null || membershipExpiry!.isAfter(DateTime.now()));

  String get displayName => name ?? phoneNumber;

  String get initials {
    if (name == null || name!.isEmpty) return phoneNumber.substring(phoneNumber.length - 2);
    final parts = name!.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name![0].toUpperCase();
  }

  UserEntity copyWith({
    String? uid,
    String? phoneNumber,
    String? name,
    String? email,
    String? photoUrl,
    int? age,
    double? heightCm,
    double? weightKg,
    String? gender,
    String? healthGoal,
    String? activityLevel,
    String? dietPreference,
    MembershipType? membershipType,
    DateTime? membershipExpiry,
    double? bmi,
    int? dailyCalorieGoal,
    double? dailyWaterGoalLiters,
    bool? notificationsEnabled,
    bool? profileSetupDone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      age: age ?? this.age,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      gender: gender ?? this.gender,
      healthGoal: healthGoal ?? this.healthGoal,
      activityLevel: activityLevel ?? this.activityLevel,
      dietPreference: dietPreference ?? this.dietPreference,
      membershipType: membershipType ?? this.membershipType,
      membershipExpiry: membershipExpiry ?? this.membershipExpiry,
      bmi: bmi ?? this.bmi,
      dailyCalorieGoal: dailyCalorieGoal ?? this.dailyCalorieGoal,
      dailyWaterGoalLiters: dailyWaterGoalLiters ?? this.dailyWaterGoalLiters,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      profileSetupDone: profileSetupDone ?? this.profileSetupDone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        phoneNumber,
        name,
        email,
        membershipType,
        profileSetupDone,
      ];
}
