import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary brand colors
  static const Color primary = Color(0xFF00C896);
  static const Color primaryDark = Color(0xFF00A87A);
  static const Color primaryLight = Color(0xFFB2F2E3);
  static const Color primaryContainer = Color(0xFFE0FAF4);

  // Secondary colors
  static const Color secondary = Color(0xFF7C4DFF);
  static const Color secondaryDark = Color(0xFF5E35B1);
  static const Color secondaryLight = Color(0xFFEDE7FF);

  // Accent
  static const Color accent = Color(0xFFFF6B35);
  static const Color accentLight = Color(0xFFFFE5DA);

  // Semantic colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF2196F3);

  // Neutral - Light Mode
  static const Color background = Color(0xFFF8FFFE);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F4F3);
  static const Color onSurface = Color(0xFF1A1C1B);
  static const Color onBackground = Color(0xFF191C1B);
  static const Color textPrimary = Color(0xFF1A1C1B);
  static const Color textSecondary = Color(0xFF3D4A47);
  static const Color textTertiary = Color(0xFF6B7978);
  static const Color divider = Color(0xFFE0E8E6);
  static const Color outline = Color(0xFFBECCCA);

  // Neutral - Dark Mode
  static const Color backgroundDark = Color(0xFF0F1614);
  static const Color surfaceDark = Color(0xFF1A2220);
  static const Color surfaceVariantDark = Color(0xFF1E2826);
  static const Color onSurfaceDark = Color(0xFFE0E8E6);
  static const Color textPrimaryDark = Color(0xFFE8F1EF);
  static const Color textSecondaryDark = Color(0xFFB0C4C0);
  static const Color textTertiaryDark = Color(0xFF7A9490);
  static const Color dividerDark = Color(0xFF2A3432);
  static const Color outlineDark = Color(0xFF3D4E4B);

  // Goal colors
  static const Color weightLoss = Color(0xFFFF5252);
  static const Color weightGain = Color(0xFF448AFF);
  static const Color pcodThyroid = Color(0xFFAB47BC);
  static const Color maintenance = Color(0xFF00C896);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00C896), Color(0xFF00E5B0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF7C4DFF), Color(0xFFAB7FFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFFF6B35), Color(0xFFFF9A76)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF1A2220), Color(0xFF0F1614)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient premiumGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
