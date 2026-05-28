class AppConstants {
  AppConstants._();

  static const String appName = 'FitMitra';
  static const String appTagline = 'Your AI Health & Wellness Companion';

  // API Keys (replace with actual keys in production)
  static const String razorpayKeyId = 'rzp_test_YOUR_KEY';
  static const String razorpayKeySecret = 'YOUR_SECRET';

  // Membership
  static const double monthlyPremiumPrice = 299.0;
  static const double yearlyPremiumPrice = 2499.0;
  static const String currency = 'INR';

  // Goals
  static const List<String> healthGoals = [
    'Weight Loss',
    'Weight Gain',
    'PCOD/Thyroid Management',
    'General Fitness',
    'Muscle Building',
    'Stress Relief',
  ];

  // Water tracking
  static const double dailyWaterGoalMl = 3000;
  static const double glassSize = 250;

  // Calorie defaults
  static const int defaultCalorieGoal = 2000;

  // Collections
  static const String usersCollection = 'users';
  static const String dietPlansCollection = 'diet_plans';
  static const String recipesCollection = 'recipes';
  static const String productsCollection = 'products';
  static const String yogaVideosCollection = 'yoga_videos';
  static const String meditationCollection = 'meditations';
  static const String chatCollection = 'ai_chats';
  static const String trackingCollection = 'daily_tracking';
  static const String mentorSessionsCollection = 'mentor_sessions';
  static const String ordersCollection = 'orders';
}
