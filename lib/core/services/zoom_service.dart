import 'package:dio/dio.dart';
import 'package:fitmitra/core/constants/app_constants.dart';
import 'package:fitmitra/features/sessions/domain/mentor_session.dart';

class ZoomService {
  ZoomService(this._dio);

  final Dio _dio;

  Future<List<MentorSession>> fetchMentorSessions() async {
    final response = await _dio.get<List<dynamic>>(AppConstants.mentorSessionEndpoint);
    final payload = response.data;
    if (payload == null) return const [];
    return payload
        .whereType<Map<String, dynamic>>()
        .map(MentorSession.fromJson)
        .toList(growable: false);
  }
}
