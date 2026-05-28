class AppEnvironment {
  const AppEnvironment._();

  static const bool firebaseConfigured = bool.fromEnvironment(
    'FITMITRA_FIREBASE_CONFIGURED',
  );
  static const String geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');
  static const String razorpayKeyId = String.fromEnvironment('RAZORPAY_KEY_ID');
  static const String supportPhone = String.fromEnvironment(
    'FITMITRA_SUPPORT_PHONE',
    defaultValue: '+919999999999',
  );

  static bool get hasGemini => geminiApiKey.trim().isNotEmpty;
  static bool get hasRazorpay => razorpayKeyId.trim().isNotEmpty;
}
