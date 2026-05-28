class AppConstants {
  AppConstants._();

  static const String appName = 'FitMitra';
  static const String appVersion = '1.0.0';
  static const String packageName = 'com.epointdigital.fitmitra';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String dietPlansCollection = 'diet_plans';
  static const String mealsCollection = 'meals';
  static const String yogaVideosCollection = 'yoga_videos';
  static const String meditationsCollection = 'meditations';
  static const String recipesCollection = 'recipes';
  static const String mentorsCollection = 'mentors';
  static const String sessionsCollection = 'sessions';
  static const String productsCollection = 'products';
  static const String chatMessagesCollection = 'chat_messages';
  static const String trackingCollection = 'tracking';
  static const String notificationsCollection = 'notifications';

  // SharedPreferences Keys
  static const String keyUserLoggedIn = 'user_logged_in';
  static const String keyUserId = 'user_id';
  static const String keyThemeMode = 'theme_mode';
  static const String keyOnboardingDone = 'onboarding_done';
  static const String keyProfileSetupDone = 'profile_setup_done';
  static const String keyFcmToken = 'fcm_token';
  static const String keyDailyCalorieGoal = 'daily_calorie_goal';
  static const String keyDailyWaterGoal = 'daily_water_goal';

  // Hive Box Names
  static const String userBox = 'user_box';
  static const String trackingBox = 'tracking_box';
  static const String cacheBox = 'cache_box';

  // Razorpay
  static const String razorpayKeyId = 'YOUR_RAZORPAY_KEY_ID';

  // Gemini AI
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY';
  static const String geminiBaseUrl = 'https://generativelanguage.googleapis.com/v1beta';

  // Zoom
  static const String zoomSdkKey = 'YOUR_ZOOM_SDK_KEY';
  static const String zoomSdkSecret = 'YOUR_ZOOM_SDK_SECRET';

  // Pagination
  static const int pageSize = 20;
  static const int chatPageSize = 50;

  // Animation durations
  static const Duration shortDuration = Duration(milliseconds: 200);
  static const Duration mediumDuration = Duration(milliseconds: 350);
  static const Duration longDuration = Duration(milliseconds: 500);
  static const Duration splashDuration = Duration(seconds: 3);

  // Daily defaults
  static const int defaultCalorieGoal = 2000;
  static const double defaultWaterGoalLiters = 2.5;
  static const int defaultStepGoal = 10000;

  // Membership plans
  static const double monthlyPlanPrice = 499.0;
  static const double quarterlyPlanPrice = 1299.0;
  static const double annualPlanPrice = 3999.0;

  // Supported goals
  static const List<String> healthGoals = [
    'Weight Loss',
    'Weight Gain',
    'PCOD/PCOS',
    'Thyroid Management',
    'Maintenance',
    'Muscle Gain',
    'Stress Relief',
  ];

  static const List<String> dietTypes = [
    'Vegetarian',
    'Non-Vegetarian',
    'Vegan',
    'Eggetarian',
    'Jain',
    'Keto',
    'Mediterranean',
  ];

  static const List<String> activityLevels = [
    'Sedentary',
    'Lightly Active',
    'Moderately Active',
    'Very Active',
    'Extra Active',
  ];
}
