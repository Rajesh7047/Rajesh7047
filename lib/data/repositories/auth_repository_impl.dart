import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitmitra/core/constants/app_constants.dart';
import 'package:fitmitra/core/errors/failures.dart';
import 'package:fitmitra/core/utils/result.dart';
import 'package:fitmitra/data/models/user_profile_model.dart';
import 'package:fitmitra/domain/entities/user_profile.dart';
import 'package:fitmitra/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  String? _verificationId;

  @override
  Stream<UserProfile?> watchCurrentUser() {
    return _auth.authStateChanges().asyncExpand((user) {
      if (user == null) return Stream.value(null);
      return _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .snapshots()
          .map((doc) {
        if (!doc.exists) {
          return UserProfileModel(
            uid: user.uid,
            phoneNumber: user.phoneNumber ?? '',
          );
        }
        return UserProfileModel.fromFirestore(doc);
      });
    });
  }

  @override
  Future<Result<String>> sendOtp(String phoneNumber) async {
    try {
      final completer = Completer<Result<String>>();
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber.startsWith('+') ? phoneNumber : '+91$phoneNumber',
        timeout: AppConstants.otpTimeout,
        verificationCompleted: (_) {},
        verificationFailed: (e) {
          if (!completer.isCompleted) {
            completer.complete(Error(AuthFailure(e.message ?? 'OTP failed')));
          }
        },
        codeSent: (verificationId, _) {
          _verificationId = verificationId;
          if (!completer.isCompleted) completer.complete(Success(verificationId));
        },
        codeAutoRetrievalTimeout: (verificationId) {
          _verificationId = verificationId;
        },
      );
      return completer.future;
    } catch (e) {
      return Error(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Result<UserProfile>> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final vid = verificationId.isNotEmpty ? verificationId : _verificationId;
      if (vid == null) {
        return const Error(AuthFailure('Request OTP first.'));
      }
      final credential = PhoneAuthProvider.credential(
        verificationId: vid,
        smsCode: smsCode,
      );
      final userCred = await _auth.signInWithCredential(credential);
      final user = userCred.user!;
      final profile = UserProfileModel(
        uid: user.uid,
        phoneNumber: user.phoneNumber ?? '',
        createdAt: DateTime.now(),
      );
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .set(profile.toFirestore(), SetOptions(merge: true));
      return Success(profile);
    } on FirebaseAuthException catch (e) {
      return Error(AuthFailure(e.message ?? 'Invalid OTP'));
    } catch (e) {
      return Error(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _auth.signOut();
      return const Success(null);
    } catch (e) {
      return Error(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Result<UserProfile>> updateProfile(UserProfile profile) async {
    try {
      final model = UserProfileModel(
        uid: profile.uid,
        phoneNumber: profile.phoneNumber,
        displayName: profile.displayName,
        email: profile.email,
        healthGoalId: profile.healthGoalId,
        isPremium: profile.isPremium,
        premiumExpiresAt: profile.premiumExpiresAt,
        dailyCalorieGoal: profile.dailyCalorieGoal,
        dailyWaterGoalMl: profile.dailyWaterGoalMl,
        createdAt: profile.createdAt,
      );
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(profile.uid)
          .set(model.toFirestore(), SetOptions(merge: true));
      return Success(profile);
    } catch (e) {
      return Error(ServerFailure(e.toString()));
    }
  }
}
