import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/app_environment.dart';
import '../data/ai_health_repository.dart';
import '../data/auth_repository.dart';
import '../data/demo_seed_data.dart';
import '../data/payment_repository.dart';
import '../data/tracker_repository.dart';
import '../data/wellness_repository.dart';
import '../domain/models.dart';

final firebaseAuthProvider = Provider<FirebaseAuth?>((ref) {
  return AppEnvironment.firebaseConfigured ? FirebaseAuth.instance : null;
});

final firestoreProvider = Provider<FirebaseFirestore?>((ref) {
  return AppEnvironment.firebaseConfigured ? FirebaseFirestore.instance : null;
});

final storageProvider = Provider<FirebaseStorage?>((ref) {
  return AppEnvironment.firebaseConfigured ? FirebaseStorage.instance : null;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(firebaseAuthProvider), ref.watch(firestoreProvider));
});

final wellnessRepositoryProvider = Provider<WellnessRepository>((ref) {
  return WellnessRepository(ref.watch(firestoreProvider), ref.watch(storageProvider));
});

final aiHealthRepositoryProvider = Provider<AiHealthRepository>((ref) {
  return AiHealthRepository();
});

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepository(ref.watch(firestoreProvider));
});

final trackerRepositoryProvider = Provider<TrackerRepository>((ref) {
  return TrackerRepository(ref.watch(firestoreProvider));
});

final authStateProvider = StreamProvider<AppUser?>((ref) {
  return ref.watch(authRepositoryProvider).authState();
});

final selectedGoalProvider = StateProvider<HealthGoal>((ref) => HealthGoal.weightLoss);

final activeMembershipProvider = Provider<MembershipTier>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  return user?.hasActivePremium == true ? MembershipTier.premium : MembershipTier.free;
});

final dietPlanProvider = Provider<DietPlan>((ref) {
  return DemoSeedData.dietPlan(ref.watch(selectedGoalProvider));
});

final wellnessContentProvider = StreamProvider.family<List<WellnessContent>, ContentType?>((ref, type) {
  return ref.watch(wellnessRepositoryProvider).watchContent(type: type);
});

final productRecommendationsProvider = StreamProvider<List<ProductRecommendation>>((ref) {
  return ref.watch(wellnessRepositoryProvider).watchProducts(ref.watch(selectedGoalProvider));
});

final mentorSessionsProvider = StreamProvider<List<MentorSession>>((ref) {
  return ref.watch(wellnessRepositoryProvider).watchMentorSessions();
});

final themeModeProvider = StateNotifierProvider<ThemeModeController, ThemeMode>((ref) {
  return ThemeModeController();
});

class ThemeModeController extends StateNotifier<ThemeMode> {
  ThemeModeController() : super(ThemeMode.system);

  void setThemeMode(ThemeMode mode) => state = mode;
}

final dailyTrackerProvider = StateNotifierProvider<DailyTrackerController, DailyTrackerState>((ref) {
  final dietPlan = ref.watch(dietPlanProvider);
  final authUser = ref.watch(authStateProvider).valueOrNull;
  return DailyTrackerController(
    repository: ref.watch(trackerRepositoryProvider),
    uid: authUser?.uid ?? 'guest',
    initialState: DailyTrackerState(
      caloriesConsumed: 920,
      calorieTarget: dietPlan.calorieTarget,
      waterConsumedMl: 1400,
      waterTargetMl: dietPlan.waterTargetMl,
    ),
  );
});

class DailyTrackerController extends StateNotifier<DailyTrackerState> {
  DailyTrackerController({
    required TrackerRepository repository,
    required String uid,
    required DailyTrackerState initialState,
  })  : _repository = repository,
        _uid = uid,
        super(initialState);

  final TrackerRepository _repository;
  final String _uid;

  Future<void> addWater(int ml) async {
    state = state.copyWith(waterConsumedMl: state.waterConsumedMl + ml);
    await _persist();
  }

  Future<void> addCalories(int calories) async {
    state = state.copyWith(caloriesConsumed: state.caloriesConsumed + calories);
    await _persist();
  }

  Future<void> _persist() {
    return _repository.saveDailyMetrics(
      uid: _uid,
      date: DateTime.now(),
      calories: state.caloriesConsumed,
      waterMl: state.waterConsumedMl,
    );
  }
}
