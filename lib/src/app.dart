import 'package:fitmitra/src/core/config/app_config.dart';
import 'package:fitmitra/src/core/router/app_router.dart';
import 'package:fitmitra/src/core/theme/app_theme.dart';
import 'package:fitmitra/src/core/theme/theme_mode_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FitMitraApp extends ConsumerWidget {
  const FitMitraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
