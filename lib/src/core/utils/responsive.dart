import 'package:fitmitra/src/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

class Responsive {
  const Responsive._();

  static double width(BuildContext context) => MediaQuery.sizeOf(context).width;

  static bool isMobile(BuildContext context) =>
      width(context) < AppConstants.mobileBreakpoint;

  static bool isDesktop(BuildContext context) =>
      width(context) >= AppConstants.desktopBreakpoint;

  static int columns(
    BuildContext context, {
    int mobile = 1,
    int tablet = 2,
    int desktop = 4,
  }) {
    if (isDesktop(context)) {
      return desktop;
    }
    if (isMobile(context)) {
      return mobile;
    }
    return tablet;
  }

  static double contentWidth(BuildContext context) {
    final currentWidth = width(context);
    if (currentWidth >= 1440) {
      return 1280;
    }
    if (currentWidth >= 1180) {
      return currentWidth - 64;
    }
    return currentWidth;
  }
}
