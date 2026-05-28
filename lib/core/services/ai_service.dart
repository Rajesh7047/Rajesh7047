import 'package:dio/dio.dart';
import 'package:fitmitra/core/constants/app_constants.dart';

class AiService {
  AiService(this._dio);

  final Dio _dio;

  Future<String> askHealthAssistant({
    required String uid,
    required String prompt,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      AppConstants.aiChatEndpoint,
      data: {'uid': uid, 'prompt': prompt},
    );
    return response.data?['reply'] as String? ??
        'Focus on balanced meals, hydration, and consistent movement.';
  }
}
