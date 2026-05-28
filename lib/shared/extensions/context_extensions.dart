import 'package:flutter/material.dart';

extension ContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => theme.colorScheme;
  TextTheme get text => theme.textTheme;
  Size get screenSize => MediaQuery.sizeOf(this);
  bool get isWide => screenSize.width >= 600;
}
