import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String phone;
  final String? email;
  final String? photoUrl;
  final int? age;
  final double? weight;
  final double? height;
  final String? gender;
  final String? goal;
  final bool isPremium;
  final DateTime? premiumExpiry;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.phone,
    this.email,
    this.photoUrl,
    this.age,
    this.weight,
    this.height,
    this.gender,
    this.goal,
    this.isPremium = false,
    this.premiumExpiry,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'],
      photoUrl: data['photoUrl'],
      age: data['age'],
      weight: (data['weight'] as num?)?.toDouble(),
      height: (data['height'] as num?)?.toDouble(),
      gender: data['gender'],
      goal: data['goal'],
      isPremium: data['isPremium'] ?? false,
      premiumExpiry: data['premiumExpiry'] != null
          ? (data['premiumExpiry'] as Timestamp).toDate()
          : null,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'photoUrl': photoUrl,
      'age': age,
      'weight': weight,
      'height': height,
      'gender': gender,
      'goal': goal,
      'isPremium': isPremium,
      'premiumExpiry': premiumExpiry != null ? Timestamp.fromDate(premiumExpiry!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    };
  }

  UserModel copyWith({
    String? name,
    String? phone,
    String? email,
    String? photoUrl,
    int? age,
    double? weight,
    double? height,
    String? gender,
    String? goal,
    bool? isPremium,
    DateTime? premiumExpiry,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      gender: gender ?? this.gender,
      goal: goal ?? this.goal,
      isPremium: isPremium ?? this.isPremium,
      premiumExpiry: premiumExpiry ?? this.premiumExpiry,
      createdAt: createdAt,
    );
  }

  double? get bmi {
    if (weight != null && height != null && height! > 0) {
      return weight! / ((height! / 100) * (height! / 100));
    }
    return null;
  }

  String get bmiCategory {
    final b = bmi;
    if (b == null) return 'Unknown';
    if (b < 18.5) return 'Underweight';
    if (b < 25) return 'Normal';
    if (b < 30) return 'Overweight';
    return 'Obese';
  }
}
