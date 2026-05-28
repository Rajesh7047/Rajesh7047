import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitmitra/core/utils/date_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrackingState {
  const TrackingState({this.calories = 0, this.waterMl = 0});

  final int calories;
  final int waterMl;

  TrackingState copyWith({int? calories, int? waterMl}) {
    return TrackingState(
      calories: calories ?? this.calories,
      waterMl: waterMl ?? this.waterMl,
    );
  }
}

final trackerControllerProvider =
    StateNotifierProvider<TrackerController, TrackingState>((ref) {
  return TrackerController(FirebaseFirestore.instance);
});

class TrackerController extends StateNotifier<TrackingState> {
  TrackerController(this._firestore) : super(const TrackingState());

  final FirebaseFirestore _firestore;

  Future<void> addCalories({required String uid, required int calories}) async {
    state = state.copyWith(calories: state.calories + calories);
    await _persist(uid);
  }

  Future<void> addWater({required String uid, required int waterMl}) async {
    state = state.copyWith(waterMl: state.waterMl + waterMl);
    await _persist(uid);
  }

  Future<void> _persist(String uid) {
    final key = AppDateUtils.dayKey(DateTime.now());
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('tracking')
        .doc(key)
        .set({'calories': state.calories, 'waterMl': state.waterMl}, SetOptions(merge: true));
  }
}
