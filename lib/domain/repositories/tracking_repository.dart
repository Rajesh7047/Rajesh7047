import 'package:fitmitra/core/utils/result.dart';
import 'package:fitmitra/domain/entities/daily_tracking.dart';

abstract class TrackingRepository {
  Future<Result<DailyTracking>> getTodayTracking(String userId);
  Future<Result<DailyTracking>> addCalories(String userId, double amount);
  Future<Result<DailyTracking>> addWater(String userId, double ml);
}
