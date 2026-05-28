import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension ContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  double get screenWidth => mediaQuery.size.width;
  double get screenHeight => mediaQuery.size.height;
  bool get isDarkMode => theme.brightness == Brightness.dark;

  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colorScheme.error : colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

extension StringExtension on String {
  String get capitalize => isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
  String get initials {
    final words = trim().split(' ');
    if (words.length >= 2) return '${words[0][0]}${words[1][0]}'.toUpperCase();
    return isEmpty ? '' : this[0].toUpperCase();
  }
}

extension DateTimeExtension on DateTime {
  String get formatted => DateFormat('dd MMM yyyy').format(this);
  String get timeFormatted => DateFormat('hh:mm a').format(this);
  String get dayMonth => DateFormat('dd MMM').format(this);
  String get relative {
    final now = DateTime.now();
    final diff = now.difference(this);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return formatted;
  }
}

extension NumExtension on num {
  String get calorieFormat => '${toStringAsFixed(0)} kcal';
  String get mlFormat => '${toStringAsFixed(0)} ml';
}
