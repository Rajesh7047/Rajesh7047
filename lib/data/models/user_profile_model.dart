import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitmitra/domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.uid,
    required super.phoneNumber,
    super.displayName,
    super.email,
    super.healthGoalId,
    super.isPremium = false,
    super.premiumExpiresAt,
    super.dailyCalorieGoal = 2000,
    super.dailyWaterGoalMl = 2500,
    super.createdAt,
  });

  factory UserProfileModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return UserProfileModel(
      uid: doc.id,
      phoneNumber: data['phoneNumber'] as String? ?? '',
      displayName: data['displayName'] as String?,
      email: data['email'] as String?,
      healthGoalId: data['healthGoalId'] as String?,
      isPremium: data['isPremium'] as bool? ?? false,
      premiumExpiresAt: (data['premiumExpiresAt'] as Timestamp?)?.toDate(),
      dailyCalorieGoal: (data['dailyCalorieGoal'] as num?)?.toDouble() ?? 2000,
      dailyWaterGoalMl: (data['dailyWaterGoalMl'] as num?)?.toDouble() ?? 2500,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'phoneNumber': phoneNumber,
        'displayName': displayName,
        'email': email,
        'healthGoalId': healthGoalId,
        'isPremium': isPremium,
        'premiumExpiresAt': premiumExpiresAt != null
            ? Timestamp.fromDate(premiumExpiresAt!)
            : null,
        'dailyCalorieGoal': dailyCalorieGoal,
        'dailyWaterGoalMl': dailyWaterGoalMl,
        'createdAt': createdAt != null
            ? Timestamp.fromDate(createdAt!)
            : FieldValue.serverTimestamp(),
      };

  UserProfile toEntity() => UserProfile(
        uid: uid,
        phoneNumber: phoneNumber,
        displayName: displayName,
        email: email,
        healthGoalId: healthGoalId,
        isPremium: isPremium,
        premiumExpiresAt: premiumExpiresAt,
        dailyCalorieGoal: dailyCalorieGoal,
        dailyWaterGoalMl: dailyWaterGoalMl,
        createdAt: createdAt,
      );
}
