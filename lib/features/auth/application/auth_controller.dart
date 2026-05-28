import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmitra/features/auth/data/firebase_auth_repository.dart';
import 'package:fitmitra/features/auth/domain/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthUiState {
  const AuthUiState({
    this.loading = false,
    this.error,
    this.verificationId,
    this.codeSent = false,
  });

  final bool loading;
  final String? error;
  final String? verificationId;
  final bool codeSent;

  AuthUiState copyWith({
    bool? loading,
    String? error,
    String? verificationId,
    bool? codeSent,
  }) {
    return AuthUiState(
      loading: loading ?? this.loading,
      error: error,
      verificationId: verificationId ?? this.verificationId,
      codeSent: codeSent ?? this.codeSent,
    );
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository(FirebaseAuth.instance);
});

final authControllerProvider = StateNotifierProvider<AuthController, AuthUiState>((ref) {
  return AuthController(ref.read(authRepositoryProvider));
});

class AuthController extends StateNotifier<AuthUiState> {
  AuthController(this._repository) : super(const AuthUiState());

  final AuthRepository _repository;

  Future<void> requestOtp(String rawPhone) async {
    final phone = rawPhone.trim();
    state = state.copyWith(loading: true, error: null);

    await _repository.verifyPhoneNumber(
      phoneNumber: phone,
      onCodeSent: (verificationId, _) {
        state = state.copyWith(
          loading: false,
          verificationId: verificationId,
          codeSent: true,
        );
      },
      onVerificationFailed: (error) {
        state = state.copyWith(loading: false, error: error.message, codeSent: false);
      },
      onVerificationCompleted: (credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        state = state.copyWith(loading: false, codeSent: true);
      },
      onCodeAutoRetrievalTimeout: (verificationId) {
        state = state.copyWith(loading: false, verificationId: verificationId);
      },
    );
  }

  Future<bool> verifyOtp(String code) async {
    final verificationId = state.verificationId;
    if (verificationId == null) {
      state = state.copyWith(error: 'Request OTP first.');
      return false;
    }

    state = state.copyWith(loading: true, error: null);
    try {
      await _repository.signInWithOtp(verificationId: verificationId, smsCode: code.trim());
      state = state.copyWith(loading: false);
      return true;
    } on FirebaseAuthException catch (error) {
      state = state.copyWith(loading: false, error: error.message);
      return false;
    }
  }
}
