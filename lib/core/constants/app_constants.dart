/// App-wide constants for FitMitra.
class AppConstants {
  AppConstants._();

  static const String appName = 'FitMitra';
  static const String packageId = 'com.epointdigital.fitmitra';

  static const int freeAiMessagesPerDay = 5;
  static const int premiumAiMessagesPerDay = 100;
  static const double defaultWaterGoalMl = 2500;
  static const double defaultCalorieGoal = 2000;

  static const String usersCollection = 'users';
  static const String dietPlansCollection = 'diet_plans';
  static const String videosCollection = 'videos';
  static const String productsCollection = 'products';
  static const String sessionsCollection = 'mentor_sessions';
  static const String trackingCollection = 'daily_tracking';
  static const String chatHistoryCollection = 'ai_chat_history';
  static const String membershipsCollection = 'memberships';

  static const Duration otpTimeout = Duration(seconds: 60);
  static const Duration animationDuration = Duration(milliseconds: 300);
}
