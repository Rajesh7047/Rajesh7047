import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/models/user_model.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/firestore_service.dart';
import '../../../../core/constants/app_constants.dart';

final authServiceProvider = Provider((ref) => AuthService());
final firestoreServiceProvider = Provider((ref) => FirestoreService());

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseService.authStateChanges;
});

final userProvider = StateNotifierProvider<UserNotifier, AsyncValue<UserModel?>>((ref) {
  return UserNotifier(ref);
});

class UserNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final Ref _ref;

  UserNotifier(this._ref) : super(const AsyncValue.loading()) {
    _init();
  }

  void _init() {
    _ref.listen(authStateProvider, (previous, next) {
      next.whenData((user) {
        if (user != null) {
          loadUser(user.uid);
        } else {
          state = const AsyncValue.data(null);
        }
      });
    });
  }

  Future<void> loadUser(String uid) async {
    try {
      state = const AsyncValue.loading();
      final firestoreService = _ref.read(firestoreServiceProvider);
      final doc = await firestoreService.getDocument(
        collection: AppConstants.usersCollection,
        docId: uid,
      );
      if (doc.exists) {
        state = AsyncValue.data(UserModel.fromFirestore(doc));
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> createUser(UserModel user) async {
    try {
      final firestoreService = _ref.read(firestoreServiceProvider);
      await firestoreService.setDocument(
        collection: AppConstants.usersCollection,
        docId: user.uid,
        data: user.toFirestore(),
      );
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      final firestoreService = _ref.read(firestoreServiceProvider);
      await firestoreService.setDocument(
        collection: AppConstants.usersCollection,
        docId: user.uid,
        data: user.toFirestore(),
      );
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> signOut() async {
    final authService = _ref.read(authServiceProvider);
    await authService.signOut();
    state = const AsyncValue.data(null);
  }
}
