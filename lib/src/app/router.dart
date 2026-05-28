import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../presentation/screens/ai_chat_screen.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/library_screen.dart';
import '../presentation/screens/login_screen.dart';
import '../presentation/screens/main_shell_screen.dart';
import '../presentation/screens/membership_screen.dart';
import '../presentation/screens/profile_screen.dart';
import '../presentation/screens/splash_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => const NoTransitionPage(child: SplashScreen()),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      _shellRoute('/home', const HomeScreen()),
      _shellRoute('/plans', const MembershipScreen()),
      _shellRoute('/chat', const AiChatScreen()),
      _shellRoute('/library', const LibraryScreen()),
      _shellRoute('/profile', const ProfileScreen()),
    ],
  );
});

GoRoute _shellRoute(String path, Widget child) {
  return GoRoute(
    path: path,
    pageBuilder: (context, state) => CustomTransitionPage<void>(
      key: state.pageKey,
      child: MainShellScreen(location: state.uri.path, child: child),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          child: child,
        );
      },
    ),
  );
}
