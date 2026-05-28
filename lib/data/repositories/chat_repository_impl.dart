import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitmitra/core/constants/app_constants.dart';

import 'package:fitmitra/core/utils/result.dart';
import 'package:fitmitra/domain/entities/chat_message.dart';
import 'package:fitmitra/domain/repositories/chat_repository.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl({
    FirebaseFirestore? firestore,
    http.Client? client,
    String? openAiApiKey,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _client = client ?? http.Client(),
        _openAiApiKey = openAiApiKey;

  final FirebaseFirestore _firestore;
  final http.Client _client;
  final String? _openAiApiKey;
  final _uuid = const Uuid();

  @override
  Future<Result<List<ChatMessage>>> getHistory(String userId) async {
    try {
      final snap = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.chatHistoryCollection)
          .orderBy('timestamp', descending: true)
          .limit(50)
          .get();
      final messages = snap.docs.map((doc) {
        final d = doc.data();
        return ChatMessage(
          id: doc.id,
          role: d['role'] == 'assistant' ? ChatRole.assistant : ChatRole.user,
          content: d['content'] as String? ?? '',
          timestamp: (d['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      }).toList();
      return Success(messages.reversed.toList());
    } catch (_) {
      return const Success([]);
    }
  }

  @override
  Future<Result<ChatMessage>> sendMessage({
    required String userId,
    required String message,
    required bool isPremium,
    String? healthGoalId,
  }) async {
    final userMsg = ChatMessage(
      id: _uuid.v4(),
      role: ChatRole.user,
      content: message,
      timestamp: DateTime.now(),
    );
    await _saveMessage(userId, userMsg);

    final replyText = await _generateReply(
      message: message,
      healthGoalId: healthGoalId,
      isPremium: isPremium,
    );

    final assistantMsg = ChatMessage(
      id: _uuid.v4(),
      role: ChatRole.assistant,
      content: replyText,
      timestamp: DateTime.now(),
    );
    await _saveMessage(userId, assistantMsg);
    return Success(assistantMsg);
  }

  Future<void> _saveMessage(String userId, ChatMessage msg) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .collection(AppConstants.chatHistoryCollection)
        .doc(msg.id)
        .set({
      'role': msg.role.name,
      'content': msg.content,
      'timestamp': Timestamp.fromDate(msg.timestamp),
    });
  }

  Future<String> _generateReply({
    required String message,
    required bool isPremium,
    String? healthGoalId,
  }) async {
    final key = _openAiApiKey;
    if (key != null && key.isNotEmpty && key != 'sk-xxxxxxxx') {
      try {
        final response = await _client.post(
          Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: {
            'Authorization': 'Bearer $key',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'model': 'gpt-4o-mini',
            'messages': [
              {
                'role': 'system',
                'content':
                    'You are FitMitra AI, a certified wellness coach. Goal: $healthGoalId. '
                    'Give concise, safe, non-medical advice. Recommend seeing a doctor for diagnoses.',
              },
              {'role': 'user', 'content': message},
            ],
            'max_tokens': isPremium ? 500 : 200,
          }),
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          final choices = data['choices'] as List;
          if (choices.isNotEmpty) {
            return choices.first['message']['content'] as String;
          }
        }
      } catch (_) {}
    }

    return _fallbackReply(message, healthGoalId);
  }

  String _fallbackReply(String message, String? goalId) {
    final goal = goalId?.replaceAll('_', ' ') ?? 'wellness';
    return 'Thanks for your question about "$message". As your FitMitra coach '
        '(goal: $goal), I recommend balanced meals, 30 min daily movement, '
        'and 7–8 hours of sleep. For personalized diet plans and unlimited AI '
        'coaching, upgrade to Premium. Always consult your physician for medical concerns.';
  }
}
