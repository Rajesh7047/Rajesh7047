import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitmitra/core/providers/network_provider.dart';
import 'package:fitmitra/core/services/ai_service.dart';
import 'package:fitmitra/features/chat/domain/ai_message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final aiServiceProvider = Provider<AiService>((ref) => AiService(ref.read(dioProvider)));

final aiChatControllerProvider =
    StateNotifierProvider<AiChatController, List<AiMessage>>((ref) {
  return AiChatController(
    aiService: ref.read(aiServiceProvider),
    firestore: FirebaseFirestore.instance,
  );
});

class AiChatController extends StateNotifier<List<AiMessage>> {
  AiChatController({
    required AiService aiService,
    required FirebaseFirestore firestore,
  })  : _aiService = aiService,
        _firestore = firestore,
        super(const []);

  final AiService _aiService;
  final FirebaseFirestore _firestore;
  final _uuid = const Uuid();

  Future<void> sendMessage({required String uid, required String prompt}) async {
    final userMessage = AiMessage(
      id: _uuid.v4(),
      text: prompt,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = [...state, userMessage];
    await _persistMessage(uid, userMessage);

    final reply = await _aiService.askHealthAssistant(uid: uid, prompt: prompt);
    final assistantMessage = AiMessage(
      id: _uuid.v4(),
      text: reply,
      isUser: false,
      timestamp: DateTime.now(),
    );

    state = [...state, assistantMessage];
    await _persistMessage(uid, assistantMessage);
  }

  Future<void> _persistMessage(String uid, AiMessage message) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('chatSessions')
        .doc('primary')
        .collection('messages')
        .doc(message.id)
        .set(message.toJson());
  }
}
