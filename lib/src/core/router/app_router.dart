import 'package:fitmitra/src/core/widgets/fitmitra_shell.dart';
import 'package:fitmitra/src/features/ai_chat/presentation/pages/ai_chat_page.dart';
import 'package:fitmitra/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:fitmitra/src/features/auth/presentation/pages/login_page.dart';
import 'package:fitmitra/src/features/auth/presentation/pages/otp_verification_page.dart';
import 'package:fitmitra/src/features/auth/presentation/pages/splash_page.dart';
import 'package:fitmitra/src/features/diet/presentation/pages/diet_plan_page.dart';
import 'package:fitmitra/src/features/home/presentation/pages/dashboard_page.dart';
import 'package:fitmitra/src/features/media/presentation/pages/media_library_page.dart';
import 'package:fitmitra/src/features/membership/presentation/pages/membership_page.dart';
import 'package:fitmitra/src/features/mentors/presentation/pages/mentor_sessions_page.dart';
import 'package:fitmitra/src/features/profile/presentation/pages/profile_page.dart';
import 'package:fitmitra/src/features/shop/presentation/pages/shop_page.dart';
import 'package:fitmitra/src/features/tracking/presentation/pages/tracker_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    redirect: (context, state) {
      final location = state.matchedLocation;
      final isAuthPath =
          location == '/login' || location == '/otp' || location == '/splash';
      final isPublicPath = isAuthPath || location == '/membership';

      if (!authState.initialized) {
        return location == '/splash' ? null : '/splash';
      }

      if (!authState.isAuthenticated) {
        if (location == '/splash') {
          return '/login';
        }
        return isPublicPath ? null : '/login';
      }

      if (isAuthPath) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/otp',
        builder: (context, state) => const OtpVerificationPage(),
      ),
      GoRoute(
        path: '/membership',
        builder: (context, state) => const MembershipPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return FitMitraShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/chat',
                builder: (context, state) => const AiChatPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/diet',
                builder: (context, state) => const DietPlanPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/media',
                builder: (context, state) => const MediaLibraryPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/tracker',
                builder: (context, state) => const TrackerPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/mentors',
                builder: (context, state) => const MentorSessionsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/shop',
                builder: (context, state) => const ShopPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
