import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/phone_login_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/profile_setup_screen.dart';
import '../../features/home/presentation/screens/main_scaffold.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/chat/presentation/screens/ai_chat_screen.dart';
import '../../features/diet/presentation/screens/diet_screen.dart';
import '../../features/diet/presentation/screens/meal_detail_screen.dart';
import '../../features/yoga/presentation/screens/yoga_screen.dart';
import '../../features/yoga/presentation/screens/video_player_screen.dart';
import '../../features/meditation/presentation/screens/meditation_screen.dart';
import '../../features/recipes/presentation/screens/recipes_screen.dart';
import '../../features/tracking/presentation/screens/tracking_screen.dart';
import '../../features/membership/presentation/screens/membership_screen.dart';
import '../../features/products/presentation/screens/products_screen.dart';
import '../../features/mentor/presentation/screens/mentor_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/settings/presentation/screens/profile_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String phoneLogin = '/login';
  static const String otp = '/otp';
  static const String profileSetup = '/profile-setup';
  static const String main = '/main';
  static const String home = '/home';
  static const String chat = '/chat';
  static const String diet = '/diet';
  static const String mealDetail = '/meal-detail';
  static const String yoga = '/yoga';
  static const String videoPlayer = '/video-player';
  static const String meditation = '/meditation';
  static const String recipes = '/recipes';
  static const String tracking = '/tracking';
  static const String membership = '/membership';
  static const String products = '/products';
  static const String mentor = '/mentor';
  static const String settings = '/settings';
  static const String profile = '/profile';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isOnAuthPage = state.matchedLocation == AppRoutes.phoneLogin ||
          state.matchedLocation == AppRoutes.otp ||
          state.matchedLocation == AppRoutes.onboarding ||
          state.matchedLocation == AppRoutes.splash;

      if (!isLoggedIn && !isOnAuthPage) {
        return AppRoutes.phoneLogin;
      }
      if (isLoggedIn && (state.matchedLocation == AppRoutes.phoneLogin ||
          state.matchedLocation == AppRoutes.otp)) {
        return AppRoutes.main;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.phoneLogin,
        builder: (context, state) => const PhoneLoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.otp,
        builder: (context, state) {
          final phone = state.extra as String? ?? '';
          return OtpScreen(phoneNumber: phone);
        },
      ),
      GoRoute(
        path: AppRoutes.profileSetup,
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.main,
            builder: (context, state) => const HomeScreen(),
            routes: [
              GoRoute(
                path: 'chat',
                builder: (context, state) => const AiChatScreen(),
              ),
              GoRoute(
                path: 'diet',
                builder: (context, state) => const DietScreen(),
                routes: [
                  GoRoute(
                    path: 'meal/:id',
                    builder: (context, state) => MealDetailScreen(
                      mealId: state.pathParameters['id'] ?? '',
                    ),
                  ),
                ],
              ),
              GoRoute(
                path: 'yoga',
                builder: (context, state) => const YogaScreen(),
                routes: [
                  GoRoute(
                    path: 'video',
                    builder: (context, state) {
                      final videoId = state.extra as String? ?? '';
                      return VideoPlayerScreen(videoId: videoId);
                    },
                  ),
                ],
              ),
              GoRoute(
                path: 'meditation',
                builder: (context, state) => const MeditationScreen(),
              ),
              GoRoute(
                path: 'recipes',
                builder: (context, state) => const RecipesScreen(),
              ),
              GoRoute(
                path: 'tracking',
                builder: (context, state) => const TrackingScreen(),
              ),
              GoRoute(
                path: 'membership',
                builder: (context, state) => const MembershipScreen(),
              ),
              GoRoute(
                path: 'products',
                builder: (context, state) => const ProductsScreen(),
              ),
              GoRoute(
                path: 'mentor',
                builder: (context, state) => const MentorScreen(),
              ),
              GoRoute(
                path: 'settings',
                builder: (context, state) => const SettingsScreen(),
              ),
              GoRoute(
                path: 'profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Page not found: ${state.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.main),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});

// Navigation helpers
extension GoRouterExtension on BuildContext {
  void goToHome() => go(AppRoutes.main);
  void goToLogin() => go(AppRoutes.phoneLogin);
  void goToOtp(String phone) => go(AppRoutes.otp, extra: phone);
  void goToProfileSetup() => go(AppRoutes.profileSetup);
  void goToChat() => go('${AppRoutes.main}/chat');
  void goToDiet() => go('${AppRoutes.main}/diet');
  void goToYoga() => go('${AppRoutes.main}/yoga');
  void goToMeditation() => go('${AppRoutes.main}/meditation');
  void goToRecipes() => go('${AppRoutes.main}/recipes');
  void goToTracking() => go('${AppRoutes.main}/tracking');
  void goToMembership() => go('${AppRoutes.main}/membership');
  void goToProducts() => go('${AppRoutes.main}/products');
  void goToMentor() => go('${AppRoutes.main}/mentor');
  void goToSettings() => go('${AppRoutes.main}/settings');
  void goToProfile() => go('${AppRoutes.main}/profile');
}
