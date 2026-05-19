// lib/core/theme/input_decoration.dart

import 'package:flutter/material.dart';
import 'colors.dart';

class CustomInputDecorationTheme {
  CustomInputDecorationTheme._();

  static InputDecorationTheme build(AppColors colors) {
    final radius = BorderRadius.circular(colors.radiusSm);

    return InputDecorationTheme(
      filled: true,
      fillColor: colors.bgInput,
      hintStyle: TextStyle(
        fontSize: 14,
        color: colors.textPrimary.withValues(alpha: 0.4),
        fontWeight: FontWeight.w300,
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      helperStyle: const TextStyle(fontSize: 11, height: 1),
      errorStyle: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: colors.error,
        height: 1,
      ),
      errorMaxLines: 1,
      border: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(width: 1, color: colors.borderSubtle),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(width: 1, color: colors.borderSubtle),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(width: 1, color: colors.accent),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(width: 1, color: colors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(width: 1, color: colors.error),
      ),
    );
  }
}