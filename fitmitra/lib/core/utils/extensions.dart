import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  EdgeInsets get padding => MediaQuery.of(this).padding;
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;
  bool get isKeyboardVisible => MediaQuery.of(this).viewInsets.bottom > 0;

  void showSnackBar(
    String message, {
    SnackBarAction? action,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        action: action,
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void showSuccessSnackBar(String message) =>
      showSnackBar(message, backgroundColor: const Color(0xFF4CAF50));

  void showErrorSnackBar(String message) =>
      showSnackBar(message, backgroundColor: const Color(0xFFE53935));
}

extension StringExtensions on String {
  String get capitalize =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1).toLowerCase()}';

  String get titleCase => split(' ').map((word) => word.capitalize).join(' ');

  bool get isValidPhone => RegExp(r'^\+?[\d\s\-]{10,15}$').hasMatch(trim());

  bool get isValidEmail =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(trim());

  bool get isNotEmpty => !isEmpty;

  String truncate(int maxLength, {String ellipsis = '...'}) =>
      length <= maxLength ? this : '${substring(0, maxLength)}$ellipsis';

  String get removeSpaces => replaceAll(' ', '');
}

extension DoubleExtensions on double {
  String get toCalories => '${toStringAsFixed(0)} kcal';

  String get toWeight => '${toStringAsFixed(1)} kg';

  String get toHeight => '${toStringAsFixed(0)} cm';

  String get toLiters => '${toStringAsFixed(1)} L';

  String get toMl => '${(this * 1000).toStringAsFixed(0)} ml';

  String get toBmi => toStringAsFixed(1);

  String get toPercent => '${(this * 100).toStringAsFixed(0)}%';

  String get toRupees => '₹${NumberFormat('#,##0.00').format(this)}';

  double get kgToLbs => this * 2.20462;

  double get lbsToKg => this / 2.20462;

  double get cmToFeet => this / 30.48;

  double get feetToCm => this * 30.48;

  double bmi(double heightCm) {
    final heightM = heightCm / 100;
    return this / (heightM * heightM);
  }
}

extension IntExtensions on int {
  String get minutesToDuration {
    if (this < 60) return '${this}min';
    final h = this ~/ 60;
    final m = this % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}min';
  }

  String get toCaloriesStr => '$this kcal';

  String get toSteps => NumberFormat('#,###').format(this);
}

extension DateTimeExtensions on DateTime {
  String get formattedDate => DateFormat('dd MMM yyyy').format(this);

  String get formattedTime => DateFormat('hh:mm a').format(this);

  String get formattedDateTime => DateFormat('dd MMM yyyy, hh:mm a').format(this);

  String get relativeTime {
    final now = DateTime.now();
    final difference = now.difference(this);
    if (difference.inSeconds < 60) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return formattedDate;
  }

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  String get greeting {
    final hour = this.hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}

extension ColorExtensions on Color {
  Color get onColor {
    final luminance = computeLuminance();
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }
}

extension WidgetExtension on Widget {
  Widget paddingAll(double value) => Padding(
        padding: EdgeInsets.all(value),
        child: this,
      );

  Widget paddingHorizontal(double value) => Padding(
        padding: EdgeInsets.symmetric(horizontal: value),
        child: this,
      );

  Widget paddingVertical(double value) => Padding(
        padding: EdgeInsets.symmetric(vertical: value),
        child: this,
      );

  Widget paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) =>
      Padding(
        padding: EdgeInsets.only(left: left, top: top, right: right, bottom: bottom),
        child: this,
      );
}
