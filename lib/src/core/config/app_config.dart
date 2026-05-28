class AppConfig {
  const AppConfig._();

  static const String appName = 'FitMitra';
  static const String packageId = 'com.epointdigital.fitmitra';

  static const String usersCollection = 'users';
  static const String chatCollection = 'ai_chats';
  static const String dietPlansCollection = 'diet_plans';
  static const String trackingCollection = 'tracking';

  static const bool enableDemoFallbacks = true;

  static const String razorpayKeyId = String.fromEnvironment(
    'RAZORPAY_KEY_ID',
    defaultValue: '',
  );
  static const String razorpayHostedCheckoutUrl = String.fromEnvironment(
    'RAZORPAY_HOSTED_CHECKOUT_URL',
    defaultValue: '',
  );
  static const String defaultMentorJoinUrl = 'https://zoom.us/';
}
