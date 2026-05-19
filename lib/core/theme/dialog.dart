// lib/core/theme/dialog.dart

import 'package:flutter/material.dart';

import 'colors.dart';

class CustomDialogTheme {
  CustomDialogTheme._();

  static DialogThemeData build(AppColors colors) {
    return DialogThemeData(
      backgroundColor: colors.bgCard,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: colors.accentBorder, width: 0.5),
        borderRadius: BorderRadius.circular(colors.radiusMd),
      ),
      titleTextStyle: TextStyle(
        fontFamily: AppColors.fontBody,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: colors.textPrimary,
      ),
      contentTextStyle: TextStyle(
        fontFamily: AppColors.fontBody,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: colors.textSecondary,
        height: 1.5,
      ),
    );
  }
}