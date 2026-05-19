import 'package:flutter/material.dart';

import 'colors.dart';

class CustomSnackBarTheme {
  CustomSnackBarTheme._();

  static SnackBarThemeData build(AppColors colors) {
    return SnackBarThemeData(
      backgroundColor: colors.bgCard,
      behavior: SnackBarBehavior.floating,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: colors.accentBorder, width: 0.5),
        borderRadius: BorderRadius.circular(colors.radiusMd),
      ),
      contentTextStyle: TextStyle(
        fontFamily: AppColors.fontBody,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: colors.textPrimary,
      ),
      actionTextColor: colors.accent,
      closeIconColor: colors.textSecondary,
    );
  }
}