import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.phoneNumber,
    super.name,
    super.email,
    super.photoUrl,
    super.age,
    super.heightCm,
    super.weightKg,
    super.gender,
    super.healthGoal,
    super.activityLevel,
    super.dietPreference,
    super.membershipType,
    super.membershipExpiry,
    super.bmi,
    super.dailyCalorieGoal,
    super.dailyWaterGoalLiters,
    super.notificationsEnabled,
    super.profileSetupDone,
    super.createdAt,
    super.updatedAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromMap(data, doc.id);
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      phoneNumber: map['phoneNumber'] as String? ?? '',
      name: map['name'] as String?,
      email: map['email'] as String?,
      photoUrl: map['photoUrl'] as String?,
      age: map['age'] as int?,
      heightCm: (map['heightCm'] as num?)?.toDouble(),
      weightKg: (map['weightKg'] as num?)?.toDouble(),
      gender: map['gender'] as String?,
      healthGoal: map['healthGoal'] as String?,
      activityLevel: map['activityLevel'] as String?,
      dietPreference: map['dietPreference'] as String?,
      membershipType: MembershipType.values.firstWhere(
        (e) => e.name == (map['membershipType'] as String? ?? 'free'),
        orElse: () => MembershipType.free,
      ),
      membershipExpiry: map['membershipExpiry'] != null
          ? (map['membershipExpiry'] as Timestamp).toDate()
          : null,
      bmi: (map['bmi'] as num?)?.toDouble(),
      dailyCalorieGoal: map['dailyCalorieGoal'] as int?,
      dailyWaterGoalLiters: (map['dailyWaterGoalLiters'] as num?)?.toDouble(),
      notificationsEnabled: map['notificationsEnabled'] as bool? ?? true,
      profileSetupDone: map['profileSetupDone'] as bool? ?? false,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phoneNumber,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (photoUrl != null) 'photoUrl': photoUrl,
      if (age != null) 'age': age,
      if (heightCm != null) 'heightCm': heightCm,
      if (weightKg != null) 'weightKg': weightKg,
      if (gender != null) 'gender': gender,
      if (healthGoal != null) 'healthGoal': healthGoal,
      if (activityLevel != null) 'activityLevel': activityLevel,
      if (dietPreference != null) 'dietPreference': dietPreference,
      'membershipType': membershipType.name,
      if (membershipExpiry != null) 'membershipExpiry': Timestamp.fromDate(membershipExpiry!),
      if (bmi != null) 'bmi': bmi,
      if (dailyCalorieGoal != null) 'dailyCalorieGoal': dailyCalorieGoal,
      if (dailyWaterGoalLiters != null) 'dailyWaterGoalLiters': dailyWaterGoalLiters,
      'notificationsEnabled': notificationsEnabled,
      'profileSetupDone': profileSetupDone,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  static Map<String, dynamic> createInitialMap(String uid, String phone) {
    return {
      'uid': uid,
      'phoneNumber': phone,
      'membershipType': 'free',
      'notificationsEnabled': true,
      'profileSetupDone': false,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  UserModel copyWithModel({
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
  }) {
    return UserModel(
      uid: uid,
      phoneNumber: phoneNumber,
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
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
