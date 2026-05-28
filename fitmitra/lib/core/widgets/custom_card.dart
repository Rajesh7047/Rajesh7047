import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double borderRadius;
  final Gradient? gradient;
  final Color? color;
  final bool hasShadow;
  final Border? border;
  final int animationIndex;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.borderRadius = 16,
    this.gradient,
    this.color,
    this.hasShadow = true,
    this.border,
    this.animationIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null
            ? (color ?? Theme.of(context).cardTheme.color)
            : null,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border ??
            Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.06)
                  : Colors.black.withOpacity(0.04),
            ),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: (isDark ? Colors.black : Colors.grey).withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: (50 * animationIndex).ms)
        .slideY(begin: 0.05, end: 0, duration: 400.ms, delay: (50 * animationIndex).ms);
  }
}
