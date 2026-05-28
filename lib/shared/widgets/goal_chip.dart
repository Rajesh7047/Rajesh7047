import 'package:flutter/material.dart';
import 'package:fitmitra/domain/entities/health_goal.dart';

class GoalChip extends StatelessWidget {
  const GoalChip({
    super.key,
    required this.goal,
    required this.selected,
    required this.onTap,
  });

  final HealthGoal goal;
  final bool selected;
  final VoidCallback onTap;

  IconData _iconFor(String name) => switch (name) {
        'trending_down' => Icons.trending_down,
        'trending_up' => Icons.trending_up,
        'favorite' => Icons.favorite,
        _ => Icons.spa,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FilterChip(
      selected: selected,
      onSelected: (_) => onTap(),
      label: Text(goal.title),
      avatar: Icon(
        _iconFor(goal.iconName),
        size: 18,
        color: selected ? theme.colorScheme.onPrimaryContainer : null,
      ),
      selectedColor: theme.colorScheme.primaryContainer,
      checkmarkColor: theme.colorScheme.primary,
    );
  }
}
