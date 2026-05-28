import 'package:fitmitra/src/core/models/membership_tier.dart';
import 'package:fitmitra/src/core/models/wellness_goal.dart';
import 'package:fitmitra/src/core/providers/core_providers.dart';
import 'package:fitmitra/src/features/auth/data/repositories/auth_repository.dart';
import 'package:fitmitra/src/features/auth/domain/models/otp_session.dart';
import 'package:fitmitra/src/features/auth/domain/models/user_profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firestoreProvider),
    preferences: ref.watch(sharedPreferencesProvider),
  );
});

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    return AuthController(ref.watch(authRepositoryProvider));
  },
);

class AuthState {
  const AuthState({
    required this.initialized,
    required this.isLoading,
    this.user,
    this.pendingOtp,
    this.errorMessage,
  });

  const AuthState.initial() : this(initialized: false, isLoading: true);

  final bool initialized;
  final bool isLoading;
  final UserProfile? user;
  final OtpSession? pendingOtp;
  final String? errorMessage;

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    bool? initialized,
    bool? isLoading,
    UserProfile? user,
    OtpSession? pendingOtp,
    String? errorMessage,
    bool clearPendingOtp = false,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      initialized: initialized ?? this.initialized,
      isLoading: isLoading ?? this.isLoading,
      user: clearUser ? null : user ?? this.user,
      pendingOtp: clearPendingOtp ? null : pendingOtp ?? this.pendingOtp,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._repository) : super(const AuthState.initial()) {
    _restoreSession();
  }

  final AuthRepository _repository;

  Future<void> _restoreSession() async {
    try {
      final user = await _repository.restoreSession();
      state = state.copyWith(
        initialized: true,
        isLoading: false,
        user: user,
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(
        initialized: true,
        isLoading: false,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> requestOtp(String phoneNumber) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final session = await _repository.requestOtp(phoneNumber);
      state = state.copyWith(
        isLoading: false,
        pendingOtp: session,
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<void> verifyOtp(String otpCode) async {
    final session = state.pendingOtp;
    if (session == null) {
      state = state.copyWith(errorMessage: 'Request an OTP before verifying.');
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final user = await _repository.verifyOtp(
        session: session,
        otpCode: otpCode,
      );
      state = state.copyWith(
        isLoading: false,
        user: user,
        clearPendingOtp: true,
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = state.copyWith(
      clearUser: true,
      clearPendingOtp: true,
      clearError: true,
    );
    state = state.copyWith(
      initialized: true,
      isLoading: false,
      clearUser: true,
    );
  }

  Future<void> updateGoal(WellnessGoal goal) async {
    final user = state.user;
    if (user == null) {
      return;
    }
    final updated = await _repository.updateProfile(user.copyWith(goal: goal));
    state = state.copyWith(user: updated);
  }

  Future<void> updateMembershipTier(MembershipTier tier) async {
    final user = state.user;
    if (user == null) {
      return;
    }
    final updated = await _repository.updateProfile(
      user.copyWith(membershipTier: tier),
    );
    state = state.copyWith(user: updated);
  }
}
