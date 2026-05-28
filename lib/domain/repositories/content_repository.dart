import 'package:fitmitra/core/utils/result.dart';
import 'package:fitmitra/domain/entities/diet_plan.dart';
import 'package:fitmitra/domain/entities/mentor_session.dart';
import 'package:fitmitra/domain/entities/product.dart';
import 'package:fitmitra/domain/entities/wellness_video.dart';

abstract class ContentRepository {
  Future<Result<List<DietPlan>>> getDietPlans({String? goalId});
  Future<Result<List<WellnessVideo>>> getVideos(VideoCategory category);
  Future<Result<List<WellnessProduct>>> getProducts({String? goalId});
  Future<Result<List<MentorSession>>> getUpcomingSessions();
}
