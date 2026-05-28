import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitmitra/src/core/config/app_config.dart';
import 'package:fitmitra/src/core/models/wellness_goal.dart';
import 'package:fitmitra/src/core/providers/core_providers.dart';
import 'package:fitmitra/src/features/ai_chat/domain/models/chat_message.dart';
import 'package:fitmitra/src/shared/data/seed_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final aiChatRepositoryProvider = Provider<AiChatRepository>((ref) {
  return AiChatRepository(ref.watch(firestoreProvider));
});

class AiChatRepository {
  AiChatRepository(this._firestore);

  final FirebaseFirestore? _firestore;
  final _uuid = const Uuid();

  ChatMessage initialGreeting(WellnessGoal goal) {
    return ChatMessage(
      id: _uuid.v4(),
      text: SeedData.introFor(goal),
      isUser: false,
      sentAt: DateTime.now(),
    );
  }

  Future<ChatMessage> sendMessage({
    required String input,
    required WellnessGoal goal,
    required bool isPremium,
    String? userId,
  }) async {
    final reply = ChatMessage(
      id: _uuid.v4(),
      text: SeedData.aiResponseFor(input, goal, isPremium: isPremium),
      isUser: false,
      sentAt: DateTime.now(),
    );

    final firestore = _firestore;
    if (firestore != null && userId != null) {
      final chatRef = firestore
          .collection(AppConfig.chatCollection)
          .doc(userId)
          .collection('messages');
      await chatRef.add({
        'role': 'user',
        'text': input,
        'sentAt': DateTime.now().millisecondsSinceEpoch,
      });
      await chatRef.add({
        'role': 'assistant',
        'text': reply.text,
        'sentAt': reply.sentAt.millisecondsSinceEpoch,
      });
    }

    return reply;
  }
}
