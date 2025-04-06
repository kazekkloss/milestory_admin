import 'package:flutter/material.dart';

import '../core_export.dart';

class CustomTabBarTheme {
  CustomTabBarTheme._();

  static final tabBarTheme = TabBarThemeData(
    overlayColor: WidgetStateProperty.all(Colors.transparent),
    labelColor: Colors.white,
    indicatorColor: Colors.white,
    unselectedLabelColor: CustomColorScheme.customColorScheme.primary,
    dividerHeight: 0,
    indicatorSize: TabBarIndicatorSize.tab,
  );
}
