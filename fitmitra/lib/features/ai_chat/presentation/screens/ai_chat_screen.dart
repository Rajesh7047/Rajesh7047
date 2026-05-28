import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({required this.text, required this.isUser, DateTime? timestamp})
      : timestamp = timestamp ?? DateTime.now();
}

final chatProvider = StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref) {
  return ChatNotifier();
});

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  ChatNotifier()
      : super([
          ChatMessage(
            text: 'Hello! I\'m your FitMitra AI Health Assistant. 🏥\n\nI can help you with:\n• Personalized diet advice\n• Exercise recommendations\n• Health tips based on your goals\n• Nutrition information\n• Wellness guidance\n\nHow can I help you today?',
            isUser: false,
          ),
        ]);

  void sendMessage(String text) {
    state = [...state, ChatMessage(text: text, isUser: true)];
    _generateResponse(text);
  }

  void _generateResponse(String userMessage) {
    final lower = userMessage.toLowerCase();
    String response;

    if (lower.contains('weight loss') || lower.contains('lose weight')) {
      response = 'For healthy weight loss, I recommend:\n\n'
          '1. **Calorie Deficit**: Aim for 500 kcal below your TDEE\n'
          '2. **High Protein**: 1.6-2.2g per kg body weight\n'
          '3. **Fiber-Rich Foods**: Vegetables, whole grains, legumes\n'
          '4. **Regular Exercise**: 150 min moderate activity/week\n'
          '5. **Stay Hydrated**: 3+ liters of water daily\n\n'
          'Would you like a detailed meal plan?';
    } else if (lower.contains('diet') || lower.contains('meal') || lower.contains('food')) {
      response = 'Here\'s a balanced Indian diet plan:\n\n'
          '🌅 **Breakfast**: Oats upma / Poha / Idli with chutney\n'
          '🥤 **Mid-Morning**: Green tea + almonds (5-6)\n'
          '🍛 **Lunch**: 2 roti + sabzi + dal + salad + curd\n'
          '🍎 **Snack**: Fruits / Makhana / Sprouts\n'
          '🌙 **Dinner**: Soup + grilled paneer/chicken + veggies\n\n'
          'Check out the Diet Plan section for detailed personalized plans!';
    } else if (lower.contains('yoga') || lower.contains('exercise')) {
      response = 'Great that you\'re interested in fitness! 🧘‍♀️\n\n'
          'For beginners, I recommend:\n'
          '• **Surya Namaskar**: 12 rounds daily\n'
          '• **Pranayama**: 10 minutes breathing exercises\n'
          '• **Walking**: 30 minutes brisk walk\n'
          '• **Basic Asanas**: Tree pose, Warrior pose, Triangle pose\n\n'
          'Check our Yoga section for guided video tutorials!';
    } else if (lower.contains('pcod') || lower.contains('pcos') || lower.contains('thyroid')) {
      response = 'For PCOD/Thyroid management:\n\n'
          '✅ **Do\'s**:\n'
          '• Anti-inflammatory foods (turmeric, ginger)\n'
          '• Regular exercise (30 min daily)\n'
          '• Adequate sleep (7-8 hours)\n'
          '• Stress management through meditation\n\n'
          '❌ **Avoid**:\n'
          '• Processed foods & refined sugar\n'
          '• Excessive dairy\n'
          '• Soy products (for thyroid)\n\n'
          'Would you like a specialized diet plan?';
    } else if (lower.contains('water') || lower.contains('hydration')) {
      response = 'Hydration is crucial for health! 💧\n\n'
          '• **Daily Goal**: 3 liters (12 glasses)\n'
          '• **Morning**: 2 glasses warm water on empty stomach\n'
          '• **Before Meals**: 1 glass 30 min before eating\n'
          '• **During Exercise**: Sip every 15-20 minutes\n'
          '• **Tip**: Set hourly reminders\n\n'
          'Track your water intake in the Tracking section!';
    } else if (lower.contains('hello') || lower.contains('hi') || lower.contains('hey')) {
      response = 'Hello! Welcome to FitMitra! 😊\n\n'
          'I\'m here to help you with your health journey. You can ask me about:\n'
          '• Diet plans & nutrition\n'
          '• Exercise & yoga\n'
          '• Weight management\n'
          '• PCOD/Thyroid care\n'
          '• Healthy recipes\n\n'
          'What would you like to know?';
    } else {
      response = 'Thank you for your question! 🤔\n\n'
          'Based on general health guidelines, I\'d recommend:\n'
          '1. Maintain a balanced diet with all nutrients\n'
          '2. Exercise regularly (at least 30 minutes daily)\n'
          '3. Stay hydrated with 3+ liters of water\n'
          '4. Get 7-8 hours of quality sleep\n'
          '5. Practice stress management techniques\n\n'
          'For more specific advice, try asking about diet plans, yoga, weight management, or specific health conditions!';
    }

    Future.delayed(const Duration(milliseconds: 800), () {
      state = [...state, ChatMessage(text: response, isUser: false)];
    });
  }
}

class AIChatScreen extends ConsumerStatefulWidget {
  const AIChatScreen({super.key});

  @override
  ConsumerState<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends ConsumerState<AIChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    ref.read(chatProvider.notifier).sendMessage(text);
    _messageController.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const CustomAppBar(title: 'AI Health Assistant'),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return _buildMessageBubble(context, msg, isDark)
                    .animate()
                    .fadeIn(duration: 300.ms)
                    .slideY(begin: 0.1, end: 0);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Ask about health, diet, yoga...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                      textInputAction: TextInputAction.send,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, ChatMessage msg, bool isDark) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        decoration: BoxDecoration(
          color: msg.isUser
              ? AppColors.primary
              : (isDark ? AppColors.cardDark : AppColors.cardLight),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(msg.isUser ? 16 : 4),
            bottomRight: Radius.circular(msg.isUser ? 4 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!msg.isUser)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.smart_toy_rounded, size: 14, color: AppColors.primary),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'FitMitra AI',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            Text(
              msg.text,
              style: TextStyle(
                color: msg.isUser ? Colors.white : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
