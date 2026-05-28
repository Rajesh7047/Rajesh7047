import 'package:fitmitra/src/core/constants/app_constants.dart';
import 'package:fitmitra/src/core/providers/core_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeModeProvider = NotifierProvider<ThemeModeController, ThemeMode>(
  ThemeModeController.new,
);

class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final key =
        ref
            .read(sharedPreferencesProvider)
            .getString(AppConstants.themePreferenceKey) ??
        ThemeMode.system.name;

    return ThemeMode.values.firstWhere(
      (mode) => mode.name == key,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> update(ThemeMode mode) async {
    state = mode;
    await ref
        .read(sharedPreferencesProvider)
        .setString(AppConstants.themePreferenceKey, mode.name);
  }
}
