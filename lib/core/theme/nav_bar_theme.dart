import 'package:flutter/material.dart';

import '../core_export.dart';

class CustomNavRailTheme {
  CustomNavRailTheme._();

  static final navRailTheme = NavigationRailThemeData(
    backgroundColor: CustomColorScheme.customColorScheme.onPrimary,
    selectedIconTheme: IconThemeData(
      color: CustomColorScheme.customColorScheme.primary,
      size: 35,
    ),
    unselectedIconTheme: IconThemeData(
      color: CustomColorScheme.customColorScheme.onSurface,
    ),
    selectedLabelTextStyle: TextStyle(
      color: CustomColorScheme.customColorScheme.primary,
    ),
    unselectedLabelTextStyle: TextStyle(
      color: CustomColorScheme.customColorScheme.onSurface,
    ),
    indicatorColor: Colors.transparent,
  );
}