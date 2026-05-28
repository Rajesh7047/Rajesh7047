import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  const MetricCard({
    required this.title,
    required this.value,
    required this.actionLabel,
    required this.onActionPressed,
    super.key,
  });

  final String title;
  final String value;
  final String actionLabel;
  final VoidCallback onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(value),
        trailing: FilledButton.tonal(
          onPressed: onActionPressed,
          child: Text(actionLabel),
        ),
      ),
    );
  }
}
