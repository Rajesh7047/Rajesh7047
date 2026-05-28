import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitmitra/src/core/config/firebase_bootstrap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('SharedPreferences override missing.'),
);

final firebaseBootstrapProvider = Provider<FirebaseBootstrapState>(
  (ref) => const FirebaseBootstrapState(isConfigured: false),
);

final firebaseAuthProvider = Provider<FirebaseAuth?>((ref) {
  final firebaseState = ref.watch(firebaseBootstrapProvider);
  if (!firebaseState.isConfigured) {
    return null;
  }
  return FirebaseAuth.instance;
});

final firestoreProvider = Provider<FirebaseFirestore?>((ref) {
  final firebaseState = ref.watch(firebaseBootstrapProvider);
  if (!firebaseState.isConfigured) {
    return null;
  }
  return FirebaseFirestore.instance;
});

final storageProvider = Provider<FirebaseStorage?>((ref) {
  final firebaseState = ref.watch(firebaseBootstrapProvider);
  if (!firebaseState.isConfigured) {
    return null;
  }
  return FirebaseStorage.instance;
});
