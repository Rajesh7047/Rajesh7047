import 'package:flutter/foundation.dart';

enum HealthGoal {
  weightLoss,
  weightGain,
  pcodThyroid;

  String get label => switch (this) {
        HealthGoal.weightLoss => 'Weight Loss',
        HealthGoal.weightGain => 'Weight Gain',
        HealthGoal.pcodThyroid => 'PCOD / Thyroid',
      };

  String get firestoreKey => switch (this) {
        HealthGoal.weightLoss => 'weight_loss',
        HealthGoal.weightGain => 'weight_gain',
        HealthGoal.pcodThyroid => 'pcod_thyroid',
      };

  static HealthGoal fromKey(String? key) => switch (key) {
        'weight_gain' => HealthGoal.weightGain,
        'pcod_thyroid' => HealthGoal.pcodThyroid,
        _ => HealthGoal.weightLoss,
      };
}

enum MembershipTier {
  free,
  premium;

  bool get isPremium => this == MembershipTier.premium;
  String get label => isPremium ? 'Premium' : 'Free';
}

enum ContentType {
  yoga,
  meditation,
  recipe;

  String get label => switch (this) {
        ContentType.yoga => 'Yoga',
        ContentType.meditation => 'Meditation',
        ContentType.recipe => 'Recipe',
      };

  String get firestoreKey => name;

  static ContentType fromKey(String? key) => switch (key) {
        'meditation' => ContentType.meditation,
        'recipe' => ContentType.recipe,
        _ => ContentType.yoga,
      };
}

@immutable
class AppUser {
  const AppUser({
    required this.uid,
    required this.phoneNumber,
    required this.displayName,
    required this.goal,
    required this.membershipTier,
    this.premiumExpiresAt,
    this.photoUrl,
  });

  final String uid;
  final String phoneNumber;
  final String displayName;
  final HealthGoal goal;
  final MembershipTier membershipTier;
  final DateTime? premiumExpiresAt;
  final String? photoUrl;

  bool get hasActivePremium {
    if (!membershipTier.isPremium) return false;
    if (premiumExpiresAt == null) return true;
    return premiumExpiresAt!.isAfter(DateTime.now());
  }

  factory AppUser.fromMap(String uid, Map<String, dynamic> data) {
    return AppUser(
      uid: uid,
      phoneNumber: data['phoneNumber'] as String? ?? '',
      displayName: data['displayName'] as String? ?? 'FitMitra Member',
      goal: HealthGoal.fromKey(data['goal'] as String?),
      membershipTier: (data['membershipTier'] as String?) == 'premium'
          ? MembershipTier.premium
          : MembershipTier.free,
      premiumExpiresAt: _readDate(data['premiumExpiresAt']),
      photoUrl: data['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        'phoneNumber': phoneNumber,
        'displayName': displayName,
        'goal': goal.firestoreKey,
        'membershipTier': membershipTier.name,
        'premiumExpiresAt': premiumExpiresAt,
        'photoUrl': photoUrl,
      };

  static DateTime? _readDate(Object? value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    try {
      final dynamic timestamp = value;
      return timestamp.toDate() as DateTime;
    } catch (_) {
      return null;
    }
  }
}

@immutable
class DietMeal {
  const DietMeal({
    required this.title,
    required this.description,
    required this.calories,
    required this.proteinGrams,
  });

  final String title;
  final String description;
  final int calories;
  final int proteinGrams;
}

@immutable
class DietPlan {
  const DietPlan({
    required this.goal,
    required this.name,
    required this.summary,
    required this.meals,
    required this.waterTargetMl,
    required this.calorieTarget,
  });

  final HealthGoal goal;
  final String name;
  final String summary;
  final List<DietMeal> meals;
  final int waterTargetMl;
  final int calorieTarget;
}

@immutable
class WellnessContent {
  const WellnessContent({
    required this.id,
    required this.title,
    required this.type,
    required this.durationMinutes,
    required this.imageUrl,
    required this.videoUrl,
    required this.isPremium,
    required this.goals,
    required this.description,
  });

  final String id;
  final String title;
  final ContentType type;
  final int durationMinutes;
  final String imageUrl;
  final String videoUrl;
  final bool isPremium;
  final List<HealthGoal> goals;
  final String description;

  factory WellnessContent.fromMap(String id, Map<String, dynamic> data) {
    final rawGoals = (data['goals'] as List<dynamic>? ?? const <dynamic>[])
        .map((dynamic item) => HealthGoal.fromKey(item as String?))
        .toList();
    return WellnessContent(
      id: id,
      title: data['title'] as String? ?? 'Wellness session',
      type: ContentType.fromKey(data['type'] as String?),
      durationMinutes: (data['durationMinutes'] as num?)?.toInt() ?? 10,
      imageUrl: data['imageUrl'] as String? ?? '',
      videoUrl: data['videoUrl'] as String? ?? '',
      isPremium: data['isPremium'] as bool? ?? false,
      goals: rawGoals.isEmpty ? HealthGoal.values : rawGoals,
      description: data['description'] as String? ?? '',
    );
  }
}

@immutable
class MentorSession {
  const MentorSession({
    required this.id,
    required this.title,
    required this.mentorName,
    required this.startsAt,
    required this.zoomUrl,
    required this.isPremium,
  });

  final String id;
  final String title;
  final String mentorName;
  final DateTime startsAt;
  final String zoomUrl;
  final bool isPremium;
}

@immutable
class ProductRecommendation {
  const ProductRecommendation({
    required this.id,
    required this.name,
    required this.goal,
    required this.reason,
    required this.imageUrl,
    required this.priceInr,
    required this.productUrl,
  });

  final String id;
  final String name;
  final HealthGoal goal;
  final String reason;
  final String imageUrl;
  final int priceInr;
  final String productUrl;
}

@immutable
class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.createdAt,
  });

  final String text;
  final bool isUser;
  final DateTime createdAt;
}

@immutable
class DailyTrackerState {
  const DailyTrackerState({
    required this.caloriesConsumed,
    required this.calorieTarget,
    required this.waterConsumedMl,
    required this.waterTargetMl,
  });

  final int caloriesConsumed;
  final int calorieTarget;
  final int waterConsumedMl;
  final int waterTargetMl;

  double get calorieProgress => _clamped(caloriesConsumed / calorieTarget);
  double get waterProgress => _clamped(waterConsumedMl / waterTargetMl);

  DailyTrackerState copyWith({
    int? caloriesConsumed,
    int? calorieTarget,
    int? waterConsumedMl,
    int? waterTargetMl,
  }) {
    return DailyTrackerState(
      caloriesConsumed: caloriesConsumed ?? this.caloriesConsumed,
      calorieTarget: calorieTarget ?? this.calorieTarget,
      waterConsumedMl: waterConsumedMl ?? this.waterConsumedMl,
      waterTargetMl: waterTargetMl ?? this.waterTargetMl,
    );
  }

  static double _clamped(double value) => value.clamp(0, 1).toDouble();
}
