import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmitra/app/fit_mitra_app.dart';
import 'package:fitmitra/features/chat/presentation/ai_chat_screen.dart';
import 'package:fitmitra/features/diet/presentation/diet_plan_screen.dart';
import 'package:fitmitra/features/media/presentation/media_library_screen.dart';
import 'package:fitmitra/features/membership/application/membership_controller.dart';
import 'package:fitmitra/features/membership/domain/membership_tier.dart';
import 'package:fitmitra/features/membership/presentation/membership_screen.dart';
import 'package:fitmitra/features/recommendations/presentation/recommendations_screen.dart';
import 'package:fitmitra/features/sessions/presentation/mentor_sessions_screen.dart';
import 'package:fitmitra/features/tracking/presentation/tracking_screen.dart';
import 'package:fitmitra/shared/widgets/responsive_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeShellScreen extends ConsumerStatefulWidget {
  const HomeShellScreen({super.key});

  @override
  ConsumerState<HomeShellScreen> createState() => _HomeShellScreenState();
}

class _HomeShellScreenState extends ConsumerState<HomeShellScreen> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      ref.read(membershipControllerProvider.notifier).refreshForUser(uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
    final tier = ref.watch(membershipControllerProvider);

    final tabs = [
      TrackingScreen(userId: userId),
      const DietPlanScreen(),
      const RecommendationsScreen(),
      AiChatScreen(userId: userId),
      const MediaLibraryScreen(),
      const MentorSessionsScreen(),
      MembershipScreen(userId: userId),
    ];

    final destinations = const [
      NavigationDestination(icon: Icon(Icons.local_fire_department_outlined), label: 'Track'),
      NavigationDestination(icon: Icon(Icons.restaurant_menu_outlined), label: 'Diet'),
      NavigationDestination(icon: Icon(Icons.shopping_bag_outlined), label: 'Products'),
      NavigationDestination(icon: Icon(Icons.smart_toy_outlined), label: 'AI Chat'),
      NavigationDestination(icon: Icon(Icons.ondemand_video_outlined), label: 'Media'),
      NavigationDestination(icon: Icon(Icons.video_camera_front_outlined), label: 'Mentors'),
      NavigationDestination(icon: Icon(Icons.workspace_premium_outlined), label: 'Premium'),
    ];

    final selectedTab = tabs[_index];
    final requiresPremium = _index == 5;
    final gatedContent = requiresPremium && tier == MembershipTier.free
        ? const _PremiumGateWidget(
            title: 'Mentor sessions are premium',
            subtitle: 'Upgrade to premium to join live Zoom coaching sessions.',
          )
        : selectedTab;

    return Scaffold(
      appBar: AppBar(
        title: const Text('FitMitra'),
        actions: [
          IconButton(
            tooltip: 'Toggle dark mode',
            onPressed: () {
              final current = ref.read(themeModeProvider);
              ref.read(themeModeProvider.notifier).state =
                  current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
            },
            icon: const Icon(Icons.dark_mode_outlined),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!context.mounted) return;
              context.go('/auth/login');
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: ResponsiveScaffold(
        currentIndex: _index,
        destinations: destinations,
        onDestinationSelected: (value) => setState(() => _index = value),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: KeyedSubtree(key: ValueKey(_index), child: gatedContent),
        ),
      ),
    );
  }
}

class _PremiumGateWidget extends StatelessWidget {
  const _PremiumGateWidget({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline_rounded, size: 36),
                const SizedBox(height: 12),
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(subtitle, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
