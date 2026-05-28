import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitmitra/core/constants/app_constants.dart';

import 'package:fitmitra/core/utils/result.dart';
import 'package:fitmitra/data/datasources/demo_content_data.dart';
import 'package:fitmitra/domain/entities/diet_plan.dart';
import 'package:fitmitra/domain/entities/mentor_session.dart';
import 'package:fitmitra/domain/entities/product.dart';
import 'package:fitmitra/domain/entities/wellness_video.dart';
import 'package:fitmitra/domain/repositories/content_repository.dart';

class ContentRepositoryImpl implements ContentRepository {
  ContentRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Future<Result<List<DietPlan>>> getDietPlans({String? goalId}) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.dietPlansCollection)
          .where('goalId', isEqualTo: goalId ?? 'general_wellness')
          .limit(10)
          .get();
      if (snapshot.docs.isEmpty) {
        return Success(DemoContentData.dietPlans(goalId));
      }
      // Extend with Firestore parsing when backend is populated
      return Success(DemoContentData.dietPlans(goalId));
    } catch (_) {
      return Success(DemoContentData.dietPlans(goalId));
    }
  }

  @override
  Future<Result<List<WellnessVideo>>> getVideos(VideoCategory category) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.videosCollection)
          .where('category', isEqualTo: category.name)
          .limit(20)
          .get();
      if (snapshot.docs.isEmpty) {
        return Success(DemoContentData.videos(category));
      }
      return Success(DemoContentData.videos(category));
    } catch (_) {
      return Success(DemoContentData.videos(category));
    }
  }

  @override
  Future<Result<List<WellnessProduct>>> getProducts({String? goalId}) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.productsCollection)
          .limit(20)
          .get();
      if (snapshot.docs.isEmpty) {
        return Success(DemoContentData.products(goalId));
      }
      return Success(DemoContentData.products(goalId));
    } catch (_) {
      return Success(DemoContentData.products(goalId));
    }
  }

  @override
  Future<Result<List<MentorSession>>> getUpcomingSessions() async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.sessionsCollection)
          .orderBy('scheduledAt')
          .limit(10)
          .get();
      if (snapshot.docs.isEmpty) {
        return Success(DemoContentData.sessions());
      }
      return Success(DemoContentData.sessions());
    } catch (_) {
      return Success(DemoContentData.sessions());
    }
  }
}
