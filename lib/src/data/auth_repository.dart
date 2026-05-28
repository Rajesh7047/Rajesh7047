import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/models.dart';

class AuthRepository {
  AuthRepository(this._auth, this._firestore);

  final FirebaseAuth? _auth;
  final FirebaseFirestore? _firestore;

  bool get isConfigured => _auth != null && _firestore != null;

  Stream<AppUser?> authState() {
    if (!isConfigured) return Stream<AppUser?>.value(null);
    return _auth!.authStateChanges().asyncMap((User? user) async {
      if (user == null) return null;
      return _ensureUserDocument(user);
    });
  }

  Future<void> sendOtp({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String message) onError,
  }) async {
    if (_auth == null) {
      onError('Firebase Auth is not configured yet. Use demo mode or configure Firebase.');
      return;
    }
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException exception) {
        onError(exception.message ?? 'OTP verification failed.');
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  Future<UserCredential> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    if (_auth == null) {
      throw StateError('Firebase Auth is not configured.');
    }
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return _auth.signInWithCredential(credential);
  }

  Future<void> signOut() async => _auth?.signOut();

  Future<void> updateGoal(String uid, HealthGoal goal) async {
    await _firestore?.collection('users').doc(uid).set(
      <String, Object?>{'goal': goal.firestoreKey, 'updatedAt': FieldValue.serverTimestamp()},
      SetOptions(merge: true),
    );
  }

  Future<AppUser> _ensureUserDocument(User user) async {
    final ref = _firestore!.collection('users').doc(user.uid);
    final snapshot = await ref.get();
    if (!snapshot.exists) {
      await ref.set(<String, Object?>{
        'phoneNumber': user.phoneNumber ?? '',
        'displayName': 'FitMitra Member',
        'goal': HealthGoal.weightLoss.firestoreKey,
        'membershipTier': MembershipTier.free.name,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return AppUser(
        uid: user.uid,
        phoneNumber: user.phoneNumber ?? '',
        displayName: 'FitMitra Member',
        goal: HealthGoal.weightLoss,
        membershipTier: MembershipTier.free,
      );
    }
    return AppUser.fromMap(user.uid, snapshot.data() ?? <String, dynamic>{});
  }
}
