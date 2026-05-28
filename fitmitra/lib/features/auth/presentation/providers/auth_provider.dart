import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/models/user_model.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/helpers.dart';

// Firebase instances
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

// Data source
final authDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(
    auth: ref.read(firebaseAuthProvider),
    firestore: ref.read(firestoreProvider),
  );
});

// Auth state stream
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(authDataSourceProvider).authStateChanges;
});

// Current user data from Firestore
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return null;

  try {
    return await ref.read(authDataSourceProvider).getUserData(user.uid);
  } catch (_) {
    return null;
  }
});

// OTP state management
class OtpState {
  final bool isLoading;
  final String? verificationId;
  final String? errorMessage;
  final bool otpSent;
  final bool isVerified;
  final int resendCountdown;
  final bool canResend;

  const OtpState({
    this.isLoading = false,
    this.verificationId,
    this.errorMessage,
    this.otpSent = false,
    this.isVerified = false,
    this.resendCountdown = 60,
    this.canResend = false,
  });

  OtpState copyWith({
    bool? isLoading,
    String? verificationId,
    String? errorMessage,
    bool? otpSent,
    bool? isVerified,
    int? resendCountdown,
    bool? canResend,
  }) {
    return OtpState(
      isLoading: isLoading ?? this.isLoading,
      verificationId: verificationId ?? this.verificationId,
      errorMessage: errorMessage,
      otpSent: otpSent ?? this.otpSent,
      isVerified: isVerified ?? this.isVerified,
      resendCountdown: resendCountdown ?? this.resendCountdown,
      canResend: canResend ?? this.canResend,
    );
  }
}

class AuthNotifier extends StateNotifier<OtpState> {
  final AuthRemoteDataSource _dataSource;
  final FirebaseFirestore _firestore; // ignore: unused_field

  AuthNotifier(this._dataSource, this._firestore) : super(const OtpState());

  Future<void> sendOtp(String phoneNumber) async {
    state = state.copyWith(isLoading: true, errorMessage: null, otpSent: false);

    await _dataSource.sendOtp(
      phoneNumber: phoneNumber,
      verificationCompleted: (credential) async {
        await _signInWithCredential(credential, phoneNumber);
      },
      verificationFailed: (exception) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: exception.message ?? 'Verification failed',
        );
      },
      codeSent: (verificationId, forceResendToken) {
        state = state.copyWith(
          isLoading: false,
          verificationId: verificationId,
          otpSent: true,
          resendCountdown: 60,
          canResend: false,
        );
        _startResendTimer();
      },
      codeAutoRetrievalTimeout: (verificationId) {
        state = state.copyWith(
          verificationId: verificationId,
          canResend: true,
        );
      },
    );
  }

  void _startResendTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (state.resendCountdown <= 1) {
        state = state.copyWith(resendCountdown: 0, canResend: true);
        return false;
      }
      state = state.copyWith(resendCountdown: state.resendCountdown - 1);
      return true;
    });
  }

  Future<bool> verifyOtp(String smsCode, String phoneNumber) async {
    final verificationId = state.verificationId;
    if (verificationId == null) return false;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final credential = await _dataSource.verifyOtp(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      if (credential.user != null) {
        await _createOrUpdateUser(credential.user!, phoneNumber);
        state = state.copyWith(isLoading: false, isVerified: true);
        return true;
      }
      state = state.copyWith(isLoading: false, errorMessage: 'Verification failed');
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<void> _signInWithCredential(
    PhoneAuthCredential credential,
    String phoneNumber,
  ) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        await _createOrUpdateUser(userCredential.user!, phoneNumber);
        state = state.copyWith(isLoading: false, isVerified: true);
      }
    } catch (_) {
      state = state.copyWith(isLoading: false, errorMessage: 'Auto sign-in failed');
    }
  }

  Future<void> _createOrUpdateUser(User firebaseUser, String phoneNumber) async {
    final docRef = _firestore
        .collection(AppConstants.usersCollection)
        .doc(firebaseUser.uid);

    final doc = await docRef.get();
    if (!doc.exists) {
      await docRef.set(UserModel.createInitialMap(firebaseUser.uid, phoneNumber));
    }
  }

  Future<void> signOut() async {
    await _dataSource.signOut();
    state = const OtpState();
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, OtpState>((ref) {
  return AuthNotifier(
    ref.read(authDataSourceProvider),
    ref.read(firestoreProvider),
  );
});

// Profile update
final profileUpdateProvider = StateNotifierProvider<ProfileNotifier, AsyncValue<void>>(
  (ref) => ProfileNotifier(
    ref.read(authDataSourceProvider),
    ref.read(firestoreProvider),
  ),
);

class ProfileNotifier extends StateNotifier<AsyncValue<void>> {
  final AuthRemoteDataSource _dataSource;
  final FirebaseFirestore _firestore;

  ProfileNotifier(this._dataSource, this._firestore) : super(const AsyncValue.data(null));

  Future<bool> updateProfile({
    required String uid,
    required String name,
    required int age,
    required double height,
    required double weight,
    required String gender,
    required String healthGoal,
    required String activityLevel,
    required String dietPreference,
  }) async {
    state = const AsyncValue.loading();
    try {
      final bmi = AppHelpers.calculateBmi(weight, height);
      final dailyCalories = AppHelpers.calculateDailyCalories(
        weightKg: weight,
        heightCm: height,
        ageYears: age,
        gender: gender,
        activityLevel: activityLevel,
        goal: healthGoal,
      );
      final waterGoal = AppHelpers.calculateWaterGoalMl(
        weightKg: weight,
        activityLevel: activityLevel,
      );

      await _dataSource.updateUserData(uid, {
        'name': name,
        'age': age,
        'heightCm': height,
        'weightKg': weight,
        'gender': gender,
        'healthGoal': healthGoal,
        'activityLevel': activityLevel,
        'dietPreference': dietPreference,
        'bmi': double.parse(bmi.toStringAsFixed(2)),
        'dailyCalorieGoal': dailyCalories,
        'dailyWaterGoalLiters': waterGoal / 1000.0,
        'profileSetupDone': true,
      });

      state = const AsyncValue.data(null);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }
}
