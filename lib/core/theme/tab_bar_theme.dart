import 'package:flutter/material.dart';

import 'colors.dart';

class CustomTabBarTheme {
  CustomTabBarTheme._();

  static TabBarThemeData build(AppColors colors) {
    return TabBarThemeData(
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      labelColor: colors.textPrimary,
      unselectedLabelColor: colors.textSecondary,
      indicatorColor: colors.accent,
      dividerHeight: 0,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: const TextStyle(
        fontFamily: AppColors.fontBody,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: const TextStyle(
        fontFamily: AppColors.fontBody,
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}