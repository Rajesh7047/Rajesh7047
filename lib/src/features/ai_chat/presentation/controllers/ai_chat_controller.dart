import 'package:fitmitra/src/core/models/wellness_goal.dart';
import 'package:fitmitra/src/features/ai_chat/data/repositories/ai_chat_repository.dart';
import 'package:fitmitra/src/features/ai_chat/domain/models/chat_message.dart';
import 'package:fitmitra/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:fitmitra/src/shared/data/seed_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final aiChatControllerProvider =
    NotifierProvider<AiChatController, AiChatState>(AiChatController.new);

class AiChatState {
  const AiChatState({required this.messages, required this.isTyping});

  final List<ChatMessage> messages;
  final bool isTyping;

  AiChatState copyWith({List<ChatMessage>? messages, bool? isTyping}) {
    return AiChatState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}

class AiChatController extends Notifier<AiChatState> {
  late final AiChatRepository _repository;
  final Uuid _uuid = const Uuid();

  @override
  AiChatState build() {
    _repository = ref.watch(aiChatRepositoryProvider);
    final goal =
        ref.read(authControllerProvider).user?.goal ?? WellnessGoal.weightLoss;
    return AiChatState(
      messages: [_repository.initialGreeting(goal)],
      isTyping: false,
    );
  }

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return;
    }

    final user = ref.read(authControllerProvider).user;
    final goal = user?.goal ?? WellnessGoal.weightLoss;
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      text: trimmed,
      isUser: true,
      sentAt: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isTyping: true,
    );

    final reply = await _repository.sendMessage(
      input: trimmed,
      goal: goal,
      isPremium: user?.isPremium ?? false,
      userId: user?.id,
    );

    state = state.copyWith(
      messages: [...state.messages, reply],
      isTyping: false,
    );
  }

  void resetConversation() {
    final goal =
        ref.read(authControllerProvider).user?.goal ?? WellnessGoal.weightLoss;
    state = AiChatState(
      messages: [_repository.initialGreeting(goal)],
      isTyping: false,
    );
  }

  List<String> suggestions() {
    final goal =
        ref.read(authControllerProvider).user?.goal ?? WellnessGoal.weightLoss;
    return SeedData.promptsFor(goal);
  }
}
