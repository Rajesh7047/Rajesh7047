import 'package:flutter/material.dart';

class Responsive {
  static late double _screenWidth;
  static late double _screenHeight;
  static late double _blockSizeHorizontal;
  static late double _blockSizeVertical;

  static void init(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;
    _blockSizeHorizontal = _screenWidth / 100;
    _blockSizeVertical = _screenHeight / 100;
  }

  static double get screenWidth => _screenWidth;
  static double get screenHeight => _screenHeight;

  static double width(double percentage) => _blockSizeHorizontal * percentage;
  static double height(double percentage) => _blockSizeVertical * percentage;

  static bool get isMobile => _screenWidth < 600;
  static bool get isTablet => _screenWidth >= 600 && _screenWidth < 1024;
  static bool get isDesktop => _screenWidth >= 1024;

  static double get horizontalPadding => isMobile ? 16 : (isTablet ? 24 : 32);
  static int get gridCrossAxisCount => isMobile ? 2 : (isTablet ? 3 : 4);
}
