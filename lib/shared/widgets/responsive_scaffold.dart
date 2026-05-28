import 'package:flutter/material.dart';

class ResponsiveScaffold extends StatelessWidget {
  const ResponsiveScaffold({
    required this.currentIndex,
    required this.destinations,
    required this.child,
    required this.onDestinationSelected,
    super.key,
  });

  final int currentIndex;
  final List<NavigationDestination> destinations;
  final Widget child;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 900) {
          return Row(
            children: [
              NavigationRail(
                selectedIndex: currentIndex,
                destinations: destinations
                    .map((destination) => NavigationRailDestination(
                          icon: destination.icon,
                          selectedIcon: destination.selectedIcon,
                          label: Text(destination.label),
                        ))
                    .toList(),
                onDestinationSelected: onDestinationSelected,
              ),
              const VerticalDivider(width: 1),
              Expanded(child: child),
            ],
          );
        }

        return Column(
          children: [
            Expanded(child: child),
            NavigationBar(
              selectedIndex: currentIndex,
              destinations: destinations,
              onDestinationSelected: onDestinationSelected,
            ),
          ],
        );
      },
    );
  }
}
