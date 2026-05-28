import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitmitra/core/constants/app_constants.dart';
import 'package:fitmitra/core/providers/theme_mode_provider.dart';
import 'package:fitmitra/core/router/app_router.dart';
import 'package:fitmitra/core/theme/app_theme.dart';

class FitMitraApp extends ConsumerWidget {
  const FitMitraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
