import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitmitra/src/core/config/app_config.dart';
import 'package:fitmitra/src/core/constants/app_constants.dart';
import 'package:fitmitra/src/core/providers/core_providers.dart';
import 'package:fitmitra/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:fitmitra/src/features/tracking/domain/models/tracker_summary.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:state_notifier/state_notifier.dart';

final trackingControllerProvider =
    StateNotifierProvider<TrackingController, TrackerSummary>((ref) {
      return TrackingController(
        preferences: ref.watch(sharedPreferencesProvider),
        firestore: ref.watch(firestoreProvider),
        ref: ref,
      );
    });

class TrackingController extends StateNotifier<TrackerSummary> {
  TrackingController({
    required SharedPreferences preferences,
    required FirebaseFirestore? firestore,
    required Ref ref,
  }) : _preferences = preferences,
       _firestore = firestore,
       _ref = ref,
       super(_loadSummary(preferences, ref));

  final SharedPreferences _preferences;
  final FirebaseFirestore? _firestore;
  final Ref _ref;

  static TrackerSummary _loadSummary(SharedPreferences prefs, Ref ref) {
    final today = _todayKey();
    final cached = prefs.getString(AppConstants.trackerCacheKey);
    if (cached == null) {
      return TrackerSummary(
        dateKey: today,
        caloriesConsumed: 0,
        calorieTarget:
            ref.read(authControllerProvider).user?.dailyCalorieTarget ??
            AppConstants.defaultCalorieGoal,
        waterMl: 0,
        waterTargetMl:
            ref.read(authControllerProvider).user?.dailyWaterTargetMl ??
            AppConstants.defaultWaterGoalMl,
      );
    }

    final summary = TrackerSummary.fromJson(
      jsonDecode(cached) as Map<String, dynamic>,
    );
    if (summary.dateKey != today) {
      return summary.copyWith(
        dateKey: today,
        caloriesConsumed: 0,
        waterMl: 0,
        calorieTarget:
            ref.read(authControllerProvider).user?.dailyCalorieTarget ??
            summary.calorieTarget,
        waterTargetMl:
            ref.read(authControllerProvider).user?.dailyWaterTargetMl ??
            summary.waterTargetMl,
      );
    }
    return summary;
  }

  void addWater(int amountMl) {
    state = state.copyWith(waterMl: state.waterMl + amountMl);
    _persist();
  }

  void logCalories(int calories) {
    state = state.copyWith(caloriesConsumed: state.caloriesConsumed + calories);
    _persist();
  }

  void resetToday() {
    state = TrackerSummary(
      dateKey: _todayKey(),
      caloriesConsumed: 0,
      calorieTarget:
          _ref.read(authControllerProvider).user?.dailyCalorieTarget ??
          AppConstants.defaultCalorieGoal,
      waterMl: 0,
      waterTargetMl:
          _ref.read(authControllerProvider).user?.dailyWaterTargetMl ??
          AppConstants.defaultWaterGoalMl,
    );
    _persist();
  }

  Future<void> _persist() async {
    await _preferences.setString(
      AppConstants.trackerCacheKey,
      jsonEncode(state.toJson()),
    );

    final user = _ref.read(authControllerProvider).user;
    if (_firestore != null && user != null) {
      await _firestore!
          .collection(AppConfig.trackingCollection)
          .doc(user.id)
          .set(state.toJson(), SetOptions(merge: true));
    }
  }

  static String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }
}
