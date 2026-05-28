import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

enum MessageRole { user, assistant }

class ChatMessage {
  final String id;
  final String content;
  final MessageRole role;
  final DateTime timestamp;
  final bool isLoading;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.role,
    required this.timestamp,
    this.isLoading = false,
  });
}

final _chatMessagesProvider = StateProvider<List<ChatMessage>>((ref) => [
      ChatMessage(
        id: const Uuid().v4(),
        content: "Hi! I'm FitMitra AI 🌿\n\nI'm your personal health & wellness assistant. I can help you with:\n• 🥗 Nutrition advice & meal plans\n• 🧘 Yoga & fitness guidance\n• 💊 Supplement recommendations\n• 🎯 Goal-based health tips\n\nHow can I help you today?",
        role: MessageRole.assistant,
        timestamp: DateTime.now(),
      ),
    ]);

final _isTypingProvider = StateProvider<bool>((ref) => false);

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();

  final _quickPrompts = [
    'What should I eat for breakfast?',
    'Give me a 7-day diet plan',
    'Best yoga for weight loss',
    'How much water should I drink?',
    'Remedies for thyroid?',
    'PCOD diet tips',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    _messageController.clear();
    FocusScope.of(context).unfocus();

    final userMessage = ChatMessage(
      id: const Uuid().v4(),
      content: text,
      role: MessageRole.user,
      timestamp: DateTime.now(),
    );

    ref.read(_chatMessagesProvider.notifier).update((msgs) => [...msgs, userMessage]);
    ref.read(_isTypingProvider.notifier).state = true;
    _scrollToBottom();

    try {
      final user = ref.read(currentUserProvider).valueOrNull;
      final systemContext = _buildSystemPrompt(user?.healthGoal, user?.dietPreference);

      final response = await _callGeminiApi(text, systemContext);

      final aiMessage = ChatMessage(
        id: const Uuid().v4(),
        content: response,
        role: MessageRole.assistant,
        timestamp: DateTime.now(),
      );

      ref.read(_chatMessagesProvider.notifier).update((msgs) => [...msgs, aiMessage]);
    } catch (e) {
      final errorMsg = ChatMessage(
        id: const Uuid().v4(),
        content: "I'm having trouble connecting right now. Please check your internet connection and try again. 🔄",
        role: MessageRole.assistant,
        timestamp: DateTime.now(),
      );
      ref.read(_chatMessagesProvider.notifier).update((msgs) => [...msgs, errorMsg]);
    } finally {
      ref.read(_isTypingProvider.notifier).state = false;
      _scrollToBottom();
    }
  }

  String _buildSystemPrompt(String? goal, String? diet) {
    return '''You are FitMitra AI, a professional health and wellness assistant specializing in Indian nutrition, yoga, and holistic wellness. 
    User's health goal: ${goal ?? 'General Wellness'}
    Diet preference: ${diet ?? 'Vegetarian'}
    
    Guidelines:
    - Provide practical, evidence-based health advice
    - Suggest Indian foods and recipes when appropriate  
    - Be empathetic, encouraging and supportive
    - Keep responses concise but comprehensive
    - Use emojis to make responses friendly
    - Always recommend consulting a doctor for medical conditions
    - Focus on sustainable, healthy habits''';
  }

  Future<String> _callGeminiApi(String userMessage, String systemPrompt) async {
    final dio = Dio();
    final apiKey = AppConstants.geminiApiKey;

    if (apiKey == 'YOUR_GEMINI_API_KEY') {
      await Future.delayed(const Duration(seconds: 1));
      return _getMockResponse(userMessage);
    }

    final response = await dio.post(
      '${AppConstants.geminiBaseUrl}/models/gemini-1.5-flash:generateContent?key=$apiKey',
      data: {
        'contents': [
          {
            'role': 'user',
            'parts': [{'text': '$systemPrompt\n\nUser: $userMessage'}]
          }
        ],
        'generationConfig': {
          'temperature': 0.7,
          'topK': 40,
          'topP': 0.95,
          'maxOutputTokens': 1024,
        },
      },
    );

    final text = response.data['candidates'][0]['content']['parts'][0]['text'] as String;
    return text;
  }

  String _getMockResponse(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('breakfast')) {
      return "🌅 **Great Breakfast Ideas for You!**\n\n**Light & Nutritious Options:**\n• 🥚 Veggie omelette with whole grain toast (250 kcal)\n• 🥣 Overnight oats with chia seeds & berries (320 kcal)\n• 🫓 Besan chilla with mint chutney (200 kcal)\n• 🥤 Smoothie bowl with banana, spinach & nuts (280 kcal)\n\n**Quick Options:**\n• Idli with sambar (light & probiotic)\n• Poha with peanuts and veggies\n\n💡 *Pro Tip: Always include protein in your breakfast to stay full longer and reduce cravings!*";
    } else if (lower.contains('yoga') || lower.contains('weight loss')) {
      return "🧘‍♀️ **Yoga for Weight Loss** — Your 30-Day Plan\n\n**Morning Routine (20 min):**\n• ☀️ Surya Namaskar × 10 rounds (200 kcal)\n• 🏋️ Warrior poses (Virabhadrasana I, II, III)\n• 🤸 Chair pose (Utkatasana) — 30 sec holds\n\n**Evening Routine (15 min):**\n• 🌊 Boat pose (Navasana)\n• 💪 Plank variations\n• 🌙 Child's pose for recovery\n\n**Benefits:** Burns 200-400 kcal/session, improves metabolism, reduces cortisol (stress hormone)\n\n⭐ *Start with our beginner yoga videos in the Yoga section!*";
    } else if (lower.contains('water')) {
      return "💧 **Daily Water Intake Guide**\n\nGeneral rule: **8 glasses (2L minimum)** but your needs depend on:\n\n• ⚖️ **Body weight**: ~35ml per kg\n• 🌡️ **Climate**: +500ml in hot weather\n• 💪 **Activity**: +500ml per hour of exercise\n\n**Your Schedule:**\n• 🌅 Morning: 2 glasses (wake up metabolism)\n• 🕙 Mid-morning: 2 glasses\n• 🕑 Afternoon: 2 glasses\n• 🌆 Evening: 2 glasses\n\n💡 *Track your water intake in the Tracking section!*";
    } else if (lower.contains('pcod') || lower.contains('pcos')) {
      return "💗 **PCOD/PCOS Management Diet Tips**\n\n**Foods to Include:**\n• 🥬 Leafy greens (spinach, methi, kale)\n• 🥒 Low-GI vegetables (broccoli, cauliflower)\n• 🌾 Whole grains (brown rice, quinoa, oats)\n• 🫘 Legumes (dal, chickpeas, lentils)\n• 🐟 Omega-3 rich foods\n\n**Foods to Avoid:**\n• ❌ Refined carbs & sugar\n• ❌ Processed foods\n• ❌ Dairy (limit if sensitive)\n\n**Lifestyle Tips:**\n• 🧘 Regular yoga & stress management\n• 💤 7-8 hours sleep\n• 🏃 30 min moderate exercise daily\n\n⚠️ *Always consult your gynecologist/endocrinologist for personalized treatment.*";
    }
    return "Thanks for your question! 😊\n\nAs your FitMitra AI, I'm here to guide you on your wellness journey. For personalized advice:\n\n• 🥗 **Diet plans** → Visit the Diet section\n• 🧘 **Yoga routines** → Check the Yoga section\n• 📊 **Track progress** → Use the Tracking section\n• 👨‍⚕️ **Expert advice** → Book a mentor session\n\nFeel free to ask me anything specific about nutrition, fitness, or wellness! 💪";
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(_chatMessagesProvider);
    final isTyping = ref.watch(_isTypingProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Icon(Icons.psychology_rounded, color: Colors.white, size: 20),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('FitMitra AI', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 4),
                    const Text('Online', style: TextStyle(fontSize: 11, color: AppColors.success, fontFamily: 'Poppins')),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: () {
              ref.read(_chatMessagesProvider.notifier).state = [
                ChatMessage(
                  id: const Uuid().v4(),
                  content: "Chat cleared! How can I help you today? 😊",
                  role: MessageRole.assistant,
                  timestamp: DateTime.now(),
                ),
              ];
            },
            tooltip: 'Clear chat',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: messages.length + (isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (isTyping && index == messages.length) {
                  return const _TypingIndicator();
                }
                return _ChatBubble(message: messages[index]);
              },
            ),
          ),

          // Quick prompts
          if (messages.length <= 1)
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _quickPrompts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) => GestureDetector(
                  onTap: () => _sendMessage(_quickPrompts[i]),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      _quickPrompts[i],
                      style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          const SizedBox(height: 8),

          // Input area
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: MediaQuery.of(context).viewInsets.bottom + 12,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    focusNode: _focusNode,
                    maxLines: 4,
                    minLines: 1,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: 'Ask FitMitra anything...',
                      filled: true,
                      fillColor: theme.colorScheme.surfaceContainerHighest,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: isTyping ? null : () => _sendMessage(_messageController.text),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: isTyping ? null : AppColors.primaryGradient,
                      color: isTyping ? theme.colorScheme.surfaceContainerHighest : null,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: isTyping
                        ? const Center(child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)))
                        : const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.psychology_rounded, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                gradient: isUser ? AppColors.primaryGradient : null,
                color: isUser ? null : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  color: isUser ? Colors.white : theme.colorScheme.onSurface,
                  fontSize: 14,
                  height: 1.5,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.psychology_rounded, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                3,
                (i) => AnimatedBuilder(
                  animation: _controller,
                  builder: (_, __) {
                    final delay = i * 0.2;
                    final opacity = ((_controller.value - delay) % 1.0).abs();
                    return Container(
                      margin: EdgeInsets.only(right: i < 2 ? 4 : 0),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: (0.3 + opacity * 0.7).clamp(0.3, 1.0)),
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
