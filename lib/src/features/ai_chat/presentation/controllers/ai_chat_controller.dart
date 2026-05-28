import 'package:fitmitra/src/core/models/wellness_goal.dart';
import 'package:fitmitra/src/features/ai_chat/data/repositories/ai_chat_repository.dart';
import 'package:fitmitra/src/features/ai_chat/domain/models/chat_message.dart';
import 'package:fitmitra/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:fitmitra/src/shared/data/seed_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:uuid/uuid.dart';

final aiChatControllerProvider =
    StateNotifierProvider<AiChatController, AiChatState>((ref) {
      return AiChatController(
        repository: ref.watch(aiChatRepositoryProvider),
        ref: ref,
      );
    });

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

class AiChatController extends StateNotifier<AiChatState> {
  AiChatController({required AiChatRepository repository, required Ref ref})
    : _repository = repository,
      _ref = ref,
      _uuid = const Uuid(),
      super(
        AiChatState(
          messages: [
            repository.initialGreeting(
              ref.read(authControllerProvider).user?.goal ??
                  WellnessGoal.weightLoss,
            ),
          ],
          isTyping: false,
        ),
      );

  final AiChatRepository _repository;
  final Ref _ref;
  final Uuid _uuid;

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return;
    }

    final user = _ref.read(authControllerProvider).user;
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
        _ref.read(authControllerProvider).user?.goal ?? WellnessGoal.weightLoss;
    state = AiChatState(
      messages: [_repository.initialGreeting(goal)],
      isTyping: false,
    );
  }

  List<String> suggestions() {
    final goal =
        _ref.read(authControllerProvider).user?.goal ?? WellnessGoal.weightLoss;
    return SeedData.promptsFor(goal);
  }
}
