import 'package:fitmitra/src/core/utils/responsive.dart';
import 'package:fitmitra/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FitMitraShell extends ConsumerWidget {
  const FitMitraShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _destinations = [
    _Destination('Home', Icons.home_rounded),
    _Destination('AI Chat', Icons.auto_awesome_rounded),
    _Destination('Diet', Icons.restaurant_menu_rounded),
    _Destination('Media', Icons.play_circle_fill_rounded),
    _Destination('Tracker', Icons.monitor_heart_rounded),
    _Destination('Mentors', Icons.groups_rounded),
    _Destination('Shop', Icons.shopping_bag_rounded),
    _Destination('Profile', Icons.person_rounded),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDesktop = Responsive.isDesktop(context);
    final isMobile = Responsive.isMobile(context);
    final user = ref.watch(authControllerProvider).user;
    final current = _destinations[navigationShell.currentIndex];

    final appBar = AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(current.label),
          if (user != null)
            Text(user.membershipTier.label, style: theme.textTheme.labelMedium),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'Premium plans',
          onPressed: () => context.push('/membership'),
          icon: const Icon(Icons.workspace_premium_rounded),
        ),
      ],
    );

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: NavigationRail(
                  selectedIndex: navigationShell.currentIndex,
                  extended: MediaQuery.sizeOf(context).width > 1320,
                  onDestinationSelected: _goToBranch,
                  destinations: [
                    for (final destination in _destinations)
                      NavigationRailDestination(
                        icon: Icon(destination.icon),
                        label: Text(destination.label),
                      ),
                  ],
                  leading: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.secondary,
                        ],
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 16,
                      ),
                      child: Icon(Icons.favorite_rounded, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: Column(
                children: [
                  appBar,
                  const Divider(height: 1),
                  Expanded(child: navigationShell),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final primaryDestinations = _destinations.take(4).toList();
    final currentBottomIndex = navigationShell.currentIndex > 3
        ? 0
        : navigationShell.currentIndex;

    return Scaffold(
      appBar: appBar,
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              ListTile(
                title: const Text('FitMitra'),
                subtitle: Text(user?.phoneNumber ?? 'AI wellness companion'),
                trailing: const Icon(Icons.favorite_rounded),
              ),
              const SizedBox(height: 8),
              for (var i = 0; i < _destinations.length; i++)
                ListTile(
                  leading: Icon(_destinations[i].icon),
                  title: Text(_destinations[i].label),
                  selected: navigationShell.currentIndex == i,
                  onTap: () {
                    Navigator.of(context).pop();
                    _goToBranch(i);
                  },
                ),
            ],
          ),
        ),
      ),
      body: navigationShell,
      bottomNavigationBar: isMobile
          ? NavigationBar(
              selectedIndex: currentBottomIndex,
              onDestinationSelected: (index) => _goToBranch(index),
              destinations: [
                for (final destination in primaryDestinations)
                  NavigationDestination(
                    icon: Icon(destination.icon),
                    label: destination.label,
                  ),
              ],
            )
          : null,
    );
  }

  void _goToBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

class _Destination {
  const _Destination(this.label, this.icon);

  final String label;
  final IconData icon;
}
