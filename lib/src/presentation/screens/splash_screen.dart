import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/fitmitra_widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: ResponsiveContent(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: FadeTransition(
              opacity: _controller,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GradientCard(
                    padding: const EdgeInsets.all(34),
                    child: const Icon(Icons.favorite_rounded, size: 72, color: Colors.white),
                  ),
                  const SizedBox(height: 28),
                  Text('FitMitra', style: textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 10),
                  Text(
                    'Your AI-powered health, diet, yoga, meditation, and mentor companion.',
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 32),
                  FilledButton.icon(
                    onPressed: () => context.go('/login'),
                    icon: const Icon(Icons.phone_android_rounded),
                    label: const Text('Start with mobile OTP'),
                  ),
                  TextButton(
                    onPressed: () => context.go('/home'),
                    child: const Text('Explore demo experience'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
