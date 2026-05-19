import 'package:flutter/material.dart';

import 'colors.dart';

/// Standard Material TextTheme — only slots that map semantically.
/// Custom styles (hero, sectionLabel, etc.) are in [AppTextStyles] extension.
class CustomTextTheme {
  CustomTextTheme._();

  static TextTheme build(AppColors colors) {
    const f = AppColors.fontBody;
    final c = colors.textPrimary;

    return TextTheme(
      // ── Headlines ──
      headlineLarge: TextStyle(
          fontFamily: f,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: c,
          letterSpacing: -0.3),
      headlineMedium: TextStyle(
          fontFamily: f, fontSize: 20, fontWeight: FontWeight.w600, color: c),
      headlineSmall: TextStyle(
          fontFamily: f, fontSize: 18, fontWeight: FontWeight.w600, color: c),

      // ── Titles ──
      titleLarge: TextStyle(
          fontFamily: f, fontSize: 16, fontWeight: FontWeight.w600, color: c),
      titleMedium: TextStyle(
          fontFamily: f, fontSize: 16, fontWeight: FontWeight.w500, color: c),
      titleSmall: TextStyle(
          fontFamily: f, fontSize: 16, fontWeight: FontWeight.w400, color: c),

      // ── Body ──
      bodyLarge: TextStyle(
          fontFamily: f, fontSize: 14, fontWeight: FontWeight.w400, color: c),
      bodyMedium: TextStyle(
          fontFamily: f, fontSize: 14, fontWeight: FontWeight.w400, color: c),
      bodySmall: TextStyle(
          fontFamily: f, fontSize: 14, fontWeight: FontWeight.w300, color: c),

      // ── Labels ──
      labelLarge: TextStyle(
          fontFamily: f, fontSize: 14, fontWeight: FontWeight.w600, color: c),
      labelMedium: TextStyle(
          fontFamily: f, fontSize: 12, fontWeight: FontWeight.w500, color: c),
      labelSmall: TextStyle(
          fontFamily: f, fontSize: 12, fontWeight: FontWeight.w300, color: c),
    );
  }
}