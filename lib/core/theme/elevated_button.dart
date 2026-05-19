import 'package:flutter/material.dart';
import 'colors.dart';

class CustomElevatedButtonTheme {
  CustomElevatedButtonTheme._();

  static ElevatedButtonThemeData build(AppColors colors) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.accent,
        foregroundColor: colors.bg,
        disabledBackgroundColor: colors.accent.withValues(alpha: 0.5),
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(colors.radiusSm),
        ),
        elevation: 0,
        minimumSize: const Size(0, 34),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        textStyle: const TextStyle(
          fontFamily: AppColors.fontBody,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}