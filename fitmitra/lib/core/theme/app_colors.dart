import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF9D97FF);
  static const Color primaryDark = Color(0xFF4A42D4);

  // Secondary
  static const Color secondary = Color(0xFF00D2FF);
  static const Color secondaryLight = Color(0xFF66E3FF);
  static const Color secondaryDark = Color(0xFF00A3CC);

  // Accent
  static const Color accent = Color(0xFFFF6584);
  static const Color accentLight = Color(0xFFFF97AB);
  static const Color accentDark = Color(0xFFCC3D5C);

  // Success / Warning / Error
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);

  // Neutral - Light
  static const Color backgroundLight = Color(0xFFF8F9FE);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF1A1D26);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color dividerLight = Color(0xFFE5E7EB);

  // Neutral - Dark
  static const Color backgroundDark = Color(0xFF0F1117);
  static const Color surfaceDark = Color(0xFF1A1D26);
  static const Color cardDark = Color(0xFF222533);
  static const Color textPrimaryDark = Color(0xFFF9FAFB);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  static const Color dividerDark = Color(0xFF374151);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient premiumGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [primary, Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
