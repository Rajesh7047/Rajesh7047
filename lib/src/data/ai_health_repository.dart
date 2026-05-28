import 'package:google_generative_ai/google_generative_ai.dart';

import '../core/app_environment.dart';
import '../domain/models.dart';

class AiHealthRepository {
  Future<ChatMessage> ask({
    required String prompt,
    required HealthGoal goal,
    required MembershipTier membershipTier,
  }) async {
    final now = DateTime.now();
    if (!AppEnvironment.hasGemini) {
      return ChatMessage(
        text: _fallbackAnswer(prompt, goal, membershipTier),
        isUser: false,
        createdAt: now,
      );
    }

    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: AppEnvironment.geminiApiKey,
      systemInstruction: Content.system(
        'You are FitMitra, a cautious AI wellness coach. Give concise, '
        'evidence-informed wellness guidance for Indian users. Never diagnose, '
        'never prescribe medication, and advise urgent medical care for red flags. '
        'Current user goal: ${goal.label}. Membership: ${membershipTier.label}.',
      ),
    );

    final response = await model.generateContent(<Content>[
      Content.text(prompt),
    ]);

    return ChatMessage(
      text: response.text?.trim().isNotEmpty == true
          ? '${response.text!.trim()}\n\nMedical note: FitMitra is educational and does not replace a doctor.'
          : _fallbackAnswer(prompt, goal, membershipTier),
      isUser: false,
      createdAt: now,
    );
  }

  String _fallbackAnswer(
    String prompt,
    HealthGoal goal,
    MembershipTier membershipTier,
  ) {
    final premiumLine = membershipTier.isPremium
        ? 'I can also help you turn this into a weekly premium plan with mentor checkpoints.'
        : 'Upgrade to Premium for detailed plans, mentor calls, and recipe videos.';
    return 'For ${goal.label}, start with a simple baseline today: protein at every meal, '
        '2.5-3L water unless restricted by your clinician, 20-30 minutes of movement, '
        'and 7+ hours of sleep. Your question was: "$prompt". $premiumLine\n\n'
        'If you have severe pain, fainting, chest symptoms, pregnancy concerns, or abnormal reports, please consult a qualified doctor.';
  }
}
