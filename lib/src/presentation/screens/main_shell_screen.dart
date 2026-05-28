import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/fitmitra_widgets.dart';

class MainShellScreen extends StatelessWidget {
  const MainShellScreen({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  static const _tabs = <_ShellTab>[
    _ShellTab('/home', 'Home', Icons.dashboard_rounded),
    _ShellTab('/plans', 'Premium', Icons.workspace_premium_rounded),
    _ShellTab('/chat', 'AI Chat', Icons.auto_awesome_rounded),
    _ShellTab('/library', 'Library', Icons.play_circle_rounded),
    _ShellTab('/profile', 'Profile', Icons.person_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _tabs.indexWhere((tab) => location.startsWith(tab.path)).clamp(0, _tabs.length - 1);
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    return Scaffold(
      body: Row(
        children: <Widget>[
          if (isWide)
            NavigationRail(
              selectedIndex: selectedIndex,
              extended: MediaQuery.sizeOf(context).width >= 1120,
              onDestinationSelected: (index) => context.go(_tabs[index].path),
              leading: const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Icon(Icons.favorite_rounded),
              ),
              destinations: _tabs
                  .map((tab) => NavigationRailDestination(
                        icon: Icon(tab.icon),
                        label: Text(tab.label),
                      ))
                  .toList(),
            ),
          Expanded(
            child: ResponsiveContent(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                child: child,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: isWide
          ? null
          : NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) => context.go(_tabs[index].path),
              destinations: _tabs
                  .map((tab) => NavigationDestination(icon: Icon(tab.icon), label: tab.label))
                  .toList(),
            ),
    );
  }
}

class _ShellTab {
  const _ShellTab(this.path, this.label, this.icon);

  final String path;
  final String label;
  final IconData icon;
}
