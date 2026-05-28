import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitmitra/core/constants/app_constants.dart';
import 'package:fitmitra/core/errors/failures.dart';
import 'package:fitmitra/core/utils/result.dart';
import 'package:fitmitra/domain/entities/daily_tracking.dart';
import 'package:fitmitra/domain/repositories/tracking_repository.dart';
import 'package:intl/intl.dart';

class TrackingRepositoryImpl implements TrackingRepository {
  TrackingRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  String _todayKey() => DateFormat('yyyy-MM-dd').format(DateTime.now());

  DocumentReference<Map<String, dynamic>> _doc(String userId) {
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .collection(AppConstants.trackingCollection)
        .doc(_todayKey());
  }

  @override
  Future<Result<DailyTracking>> getTodayTracking(String userId) async {
    try {
      final snap = await _doc(userId).get();
      if (!snap.exists) {
        return Success(DailyTracking(
          dateKey: _todayKey(),
          caloriesConsumed: 0,
          waterMl: 0,
        ));
      }
      final data = snap.data()!;
      return Success(DailyTracking(
        dateKey: _todayKey(),
        caloriesConsumed: (data['calories'] as num?)?.toDouble() ?? 0,
        waterMl: (data['waterMl'] as num?)?.toDouble() ?? 0,
        calorieGoal: (data['calorieGoal'] as num?)?.toDouble() ?? 2000,
        waterGoalMl: (data['waterGoalMl'] as num?)?.toDouble() ?? 2500,
      ));
    } catch (e) {
      return Error(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<DailyTracking>> addCalories(String userId, double amount) async {
    final current = await getTodayTracking(userId);
    return current.when(
      success: (tracking) async {
        final updated = tracking.copyWith(
          caloriesConsumed: tracking.caloriesConsumed + amount,
        );
        try {
          await _doc(userId).set({
            'calories': updated.caloriesConsumed,
            'waterMl': updated.waterMl,
            'calorieGoal': updated.calorieGoal,
            'waterGoalMl': updated.waterGoalMl,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
          return Success(updated);
        } catch (e) {
          return Error(ServerFailure(e.toString()));
        }
      },
      error: (f) => Error(f),
    );
  }

  @override
  Future<Result<DailyTracking>> addWater(String userId, double ml) async {
    final current = await getTodayTracking(userId);
    return current.when(
      success: (tracking) async {
        final updated = tracking.copyWith(waterMl: tracking.waterMl + ml);
        try {
          await _doc(userId).set({
            'calories': updated.caloriesConsumed,
            'waterMl': updated.waterMl,
            'calorieGoal': updated.calorieGoal,
            'waterGoalMl': updated.waterGoalMl,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
          return Success(updated);
        } catch (e) {
          return Error(ServerFailure(e.toString()));
        }
      },
      error: (f) => Error(f),
    );
  }
}
