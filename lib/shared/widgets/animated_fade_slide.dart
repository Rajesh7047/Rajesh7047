import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedFadeSlide extends StatelessWidget {
  const AnimatedFadeSlide({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child.animate().fadeIn(duration: 250.ms).slideY(begin: 0.08, end: 0);
  }
}
