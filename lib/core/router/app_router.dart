import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitmitra/core/providers/auth_state_provider.dart';
import 'package:fitmitra/core/providers/repository_providers.dart';
import 'package:fitmitra/features/ai_chat/presentation/pages/ai_chat_page.dart';
import 'package:fitmitra/features/auth/presentation/pages/login_page.dart';
import 'package:fitmitra/features/auth/presentation/pages/otp_page.dart';
import 'package:fitmitra/features/diet/presentation/pages/diet_plans_page.dart';
import 'package:fitmitra/features/home/presentation/pages/home_shell_page.dart';
import 'package:fitmitra/features/meditation/presentation/pages/meditation_page.dart';
import 'package:fitmitra/features/membership/presentation/pages/membership_page.dart';
import 'package:fitmitra/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:fitmitra/features/products/presentation/pages/products_page.dart';
import 'package:fitmitra/features/profile/presentation/pages/profile_page.dart';
import 'package:fitmitra/features/recipes/presentation/pages/recipes_page.dart';
import 'package:fitmitra/features/splash/presentation/pages/splash_page.dart';
import 'package:fitmitra/features/tracking/presentation/pages/tracking_page.dart';
import 'package:fitmitra/features/yoga/presentation/pages/yoga_page.dart';
import 'package:fitmitra/features/zoom_sessions/presentation/pages/zoom_sessions_page.dart';
import 'package:fitmitra/features/home/presentation/pages/video_player_page.dart';
import 'package:fitmitra/domain/entities/wellness_video.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshStream(
      ref.watch(authRepositoryProvider).watchCurrentUser(),
    ),
    redirect: (context, state) {
      final isLoading = authState.isLoading;
      final user = authState.valueOrNull;
      final path = state.matchedLocation;

      if (path == '/splash') return null;
      if (isLoading) return null;

      final isAuthRoute = path.startsWith('/login') || path.startsWith('/otp');
      final isOnboarding = path == '/onboarding';

      if (user == null && !isAuthRoute) return '/login';
      if (user != null && isAuthRoute) {
        if (user.healthGoalId == null && !isOnboarding) return '/onboarding';
        return '/home';
      }
      if (user != null &&
          user.healthGoalId == null &&
          !isOnboarding &&
          path != '/onboarding') {
        return '/onboarding';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, __) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: '/otp',
        builder: (_, state) {
          final phone = state.uri.queryParameters['phone'] ?? '';
          final vid = state.uri.queryParameters['vid'] ?? '';
          return OtpPage(phoneNumber: phone, verificationId: vid);
        },
      ),
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingPage(),
      ),
      ShellRoute(
        builder: (_, __, child) => HomeShellPage(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (_, __) => const SizedBox.shrink(),
          ),
          GoRoute(
            path: '/tracking',
            builder: (_, __) => const TrackingPage(),
          ),
          GoRoute(
            path: '/ai-chat',
            builder: (_, __) => const AiChatPage(),
          ),
          GoRoute(
            path: '/profile',
            builder: (_, __) => const ProfilePage(),
          ),
        ],
      ),
      GoRoute(
        path: '/diet',
        builder: (_, __) => const DietPlansPage(),
      ),
      GoRoute(
        path: '/yoga',
        builder: (_, __) => const YogaPage(),
      ),
      GoRoute(
        path: '/meditation',
        builder: (_, __) => const MeditationPage(),
      ),
      GoRoute(
        path: '/recipes',
        builder: (_, __) => const RecipesPage(),
      ),
      GoRoute(
        path: '/products',
        builder: (_, __) => const ProductsPage(),
      ),
      GoRoute(
        path: '/zoom',
        builder: (_, __) => const ZoomSessionsPage(),
      ),
      GoRoute(
        path: '/membership',
        builder: (_, __) => const MembershipPage(),
      ),
      GoRoute(
        path: '/video',
        builder: (_, state) {
          final extra = state.extra as WellnessVideo?;
          if (extra == null) {
            return const Scaffold(
              body: Center(child: Text('Video not found')),
            );
          }
          return VideoPlayerPage(video: extra);
        },
      ),
    ],
  );
});

/// Bridges a Stream into GoRouter refresh.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final dynamic _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
