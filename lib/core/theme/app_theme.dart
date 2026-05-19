// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';
import '../core_export.dart';

class CustomTheme {
  CustomTheme._();

  // ── DARK theme — domyślny ──
  static final ThemeData darkTheme = _build(
    colors: AppColors.dark,
    textStyles: AppTextStyles.dark,
    brightness: Brightness.dark,
  );

  // ── LIGHT theme ──
  static final ThemeData lightTheme = _build(
    colors: AppColors.light,
    textStyles: AppTextStyles.light,
    brightness: Brightness.light,
  );

  // ── Backward compat ──
  static ThemeData get theme => darkTheme;

  // ─────────────────────────────────────────────
  // Main builder
  // ─────────────────────────────────────────────
  static ThemeData _build({
    required AppColors colors,
    required AppTextStyles textStyles,
    required Brightness brightness,
  }) {
    return ThemeData(
      // ── Core ──
      brightness: brightness,
      useMaterial3: true,
      fontFamily: AppColors.fontBody,
      splashFactory: NoSplash.splashFactory,
      scaffoldBackgroundColor: colors.bg,

      // ── Color scheme ──
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors.accent,
        brightness: brightness,
      ),

      // ── Extensions ──
      extensions: [colors, textStyles],

      // ── Text ──
      textTheme: CustomTextTheme.build(colors),

      // ── Inputs ──
      inputDecorationTheme: CustomInputDecorationTheme.build(colors),

      // ── Buttons ──
      elevatedButtonTheme: CustomElevatedButtonTheme.build(colors),
      outlinedButtonTheme: CustomOutlinedButtonTheme.build(colors),

      // ── Rest components ──
      tabBarTheme: CustomTabBarTheme.build(colors),
      sliderTheme: CustomSliderTheme.build(colors),
      expansionTileTheme: CustomExpansionTileTheme.build(colors),
      dialogTheme: CustomDialogTheme.build(colors),
      listTileTheme: CustomListTileTheme.build(colors),
      snackBarTheme: CustomSnackBarTheme.build(colors),
      dropdownMenuTheme: CustomDropdownMenuTheme.build(colors),
      switchTheme: CustomSwitchTheme.build(colors),

      // ── Icon ──
      iconTheme: IconThemeData(color: colors.textPrimary),
    );
  }
}
