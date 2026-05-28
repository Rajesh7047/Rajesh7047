import 'package:flutter/material.dart';

class MetricTile extends StatelessWidget {
  const MetricTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.caption,
    this.progress,
  });

  final IconData icon;
  final String label;
  final String value;
  final String caption;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: colorScheme.primary),
            const SizedBox(height: 16),
            Text(label, style: theme.textTheme.labelLarge),
            const SizedBox(height: 6),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(caption, style: theme.textTheme.bodySmall),
            if (progress != null) ...[
              const SizedBox(height: 14),
              LinearProgressIndicator(
                value: progress!.clamp(0, 1),
                minHeight: 10,
                borderRadius: BorderRadius.circular(999),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
