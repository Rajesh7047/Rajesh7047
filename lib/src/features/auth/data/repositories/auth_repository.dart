import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmitra/src/core/config/app_config.dart';
import 'package:fitmitra/src/core/constants/app_constants.dart';
import 'package:fitmitra/src/core/models/membership_tier.dart';
import 'package:fitmitra/src/core/models/wellness_goal.dart';
import 'package:fitmitra/src/features/auth/domain/models/otp_session.dart';
import 'package:fitmitra/src/features/auth/domain/models/user_profile.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

abstract class AuthRepository {
  Future<UserProfile?> restoreSession();

  Future<OtpSession> requestOtp(String phoneNumber);

  Future<UserProfile> verifyOtp({
    required OtpSession session,
    required String otpCode,
  });

  Future<void> signOut();

  Future<UserProfile> updateProfile(UserProfile profile);
}

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    required FirebaseAuth? auth,
    required FirebaseFirestore? firestore,
    required SharedPreferences preferences,
  }) : this._(auth: auth, firestore: firestore, preferences: preferences);

  FirebaseAuthRepository._({
    required this._auth,
    required this._firestore,
    required this._preferences,
  });

  final FirebaseAuth? _auth;
  final FirebaseFirestore? _firestore;
  final SharedPreferences _preferences;
  final _uuid = const Uuid();
  final Map<String, ConfirmationResult> _webSessions = {};

  @override
  Future<UserProfile?> restoreSession() async {
    final cached = _preferences.getString(AppConstants.cachedUserKey);
    final cachedProfile = cached == null
        ? null
        : UserProfile.fromJson(jsonDecode(cached) as Map<String, dynamic>);

    final auth = _auth;
    if (auth == null) {
      return cachedProfile;
    }

    final currentUser = auth.currentUser;
    if (currentUser == null) {
      return cachedProfile;
    }

    return _upsertProfile(currentUser, fallback: cachedProfile);
  }

  @override
  Future<OtpSession> requestOtp(String phoneNumber) async {
    final auth = _auth;
    if (auth == null) {
      return OtpSession(
        sessionId: _uuid.v4(),
        phoneNumber: phoneNumber,
        isMock: true,
        debugCode: '123456',
      );
    }

    if (kIsWeb) {
      final confirmation = await auth.signInWithPhoneNumber(phoneNumber);
      final sessionId = _uuid.v4();
      _webSessions[sessionId] = confirmation;
      return OtpSession(
        sessionId: sessionId,
        phoneNumber: phoneNumber,
        isMock: false,
      );
    }

    final completer = Completer<OtpSession>();

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (_) {},
      verificationFailed: (error) {
        if (!completer.isCompleted) {
          completer.completeError(error);
        }
      },
      codeSent: (verificationId, _) {
        if (!completer.isCompleted) {
          completer.complete(
            OtpSession(
              sessionId: verificationId,
              phoneNumber: phoneNumber,
              isMock: false,
            ),
          );
        }
      },
      codeAutoRetrievalTimeout: (_) {},
    );

    return completer.future.timeout(
      const Duration(seconds: 45),
      onTimeout: () => OtpSession(
        sessionId: _uuid.v4(),
        phoneNumber: phoneNumber,
        isMock: true,
        debugCode: '123456',
      ),
    );
  }

  @override
  Future<UserProfile> verifyOtp({
    required OtpSession session,
    required String otpCode,
  }) async {
    final auth = _auth;
    if (session.isMock || auth == null) {
      final demoProfile = UserProfile(
        id: _uuid.v4(),
        phoneNumber: session.phoneNumber,
        displayName: 'Demo FitMitra User',
        goal: WellnessGoal.weightLoss,
        membershipTier: MembershipTier.free,
        dailyCalorieTarget: AppConstants.defaultCalorieGoal,
        dailyWaterTargetMl: AppConstants.defaultWaterGoalMl,
        streak: 4,
      );
      await _persistProfile(demoProfile);
      return demoProfile;
    }

    late final UserCredential credential;
    if (kIsWeb) {
      final confirmation = _webSessions.remove(session.sessionId);
      if (confirmation == null) {
        throw StateError('OTP session expired. Please request a new code.');
      }
      credential = await confirmation.confirm(otpCode);
    } else {
      credential = await auth.signInWithCredential(
        PhoneAuthProvider.credential(
          verificationId: session.sessionId,
          smsCode: otpCode,
        ),
      );
    }

    final firebaseUser = credential.user;
    if (firebaseUser == null) {
      throw StateError('Unable to verify OTP.');
    }

    return _upsertProfile(firebaseUser);
  }

  @override
  Future<void> signOut() async {
    await _auth?.signOut();
    await _preferences.remove(AppConstants.cachedUserKey);
  }

  @override
  Future<UserProfile> updateProfile(UserProfile profile) async {
    await _persistProfile(profile);
    final firestore = _firestore;
    if (firestore != null) {
      await firestore
          .collection(AppConfig.usersCollection)
          .doc(profile.id)
          .set(profile.toJson(), SetOptions(merge: true));
    }
    return profile;
  }

  Future<UserProfile> _upsertProfile(User user, {UserProfile? fallback}) async {
    UserProfile profile =
        fallback ??
        UserProfile(
          id: user.uid,
          phoneNumber: user.phoneNumber ?? '',
          displayName: user.displayName ?? 'FitMitra Member',
          goal: WellnessGoal.weightLoss,
          membershipTier: MembershipTier.free,
          dailyCalorieTarget: AppConstants.defaultCalorieGoal,
          dailyWaterTargetMl: AppConstants.defaultWaterGoalMl,
          streak: 7,
        );

    final firestore = _firestore;
    if (firestore != null) {
      final document = await firestore
          .collection(AppConfig.usersCollection)
          .doc(user.uid)
          .get();
      if (document.exists && document.data() != null) {
        profile = UserProfile.fromJson(document.data()!);
      }

      profile = profile.copyWith(
        id: user.uid,
        phoneNumber: user.phoneNumber ?? profile.phoneNumber,
        displayName: user.displayName ?? profile.displayName,
      );

      await firestore
          .collection(AppConfig.usersCollection)
          .doc(user.uid)
          .set(profile.toJson(), SetOptions(merge: true));
    }

    await _persistProfile(profile);
    return profile;
  }

  Future<void> _persistProfile(UserProfile profile) async {
    await _preferences.setString(
      AppConstants.cachedUserKey,
      jsonEncode(profile.toJson()),
    );
  }
}
