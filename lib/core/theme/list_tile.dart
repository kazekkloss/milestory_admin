import 'package:flutter/material.dart';

import 'colors.dart';

class CustomListTileTheme {
  CustomListTileTheme._();

  static ListTileThemeData build(AppColors colors) {
    return ListTileThemeData(
      contentPadding: const EdgeInsets.only(left: 16, right: 9),
      iconColor: colors.accent,
      horizontalTitleGap: 10,
      tileColor: colors.bgInput,
      titleTextStyle: TextStyle(
        fontFamily: AppColors.fontBody,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: colors.textPrimary,
      ),
      subtitleTextStyle: TextStyle(
        fontFamily: AppColors.fontBody,
        fontSize: 12,
        fontWeight: FontWeight.w300,
        color: colors.textSecondary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(colors.radiusMd),
      ),
    );
  }
}