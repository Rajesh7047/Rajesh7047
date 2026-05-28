import 'package:fitmitra/core/utils/result.dart';
import 'package:fitmitra/domain/entities/chat_message.dart';

abstract class ChatRepository {
  Future<Result<List<ChatMessage>>> getHistory(String userId);
  Future<Result<ChatMessage>> sendMessage({
    required String userId,
    required String message,
    required bool isPremium,
    String? healthGoalId,
  });
}
