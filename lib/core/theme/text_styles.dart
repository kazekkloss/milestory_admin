import 'package:flutter/material.dart';

import 'colors.dart';

/// Custom text styles accessible via:
///   `Theme.of(context).extension<AppTextStyles>()!`
///   or the shortcut: `AppTextStyles.of(context)`
///
/// These are styles that DON'T map cleanly to Material TextTheme slots.
/// Standard Material slots (bodySmall, labelMedium, etc.) stay in [CustomTextTheme].
class AppTextStyles extends ThemeExtension<AppTextStyles> {
  /// Hero headline — "Kreator Tras", "Każda droga ma swoją historię"
  final TextStyle hero;

  /// Section title — "Trzy proste kroki", "Jak to działa"
  final TextStyle sectionTitle;

  /// Section label — "JAK TO DZIAŁA" (uppercase, accent, letter-spaced)
  final TextStyle sectionLabel;

  /// Card title — step card, feature card headings
  final TextStyle cardTitle;

  /// Body/description text — secondary color, light weight
  final TextStyle body;

  /// Small caption — footer, muted info
  final TextStyle caption;

  const AppTextStyles({
    required this.hero,
    required this.sectionTitle,
    required this.sectionLabel,
    required this.cardTitle,
    required this.body,
    required this.caption,
  });

  static AppTextStyles of(BuildContext context) =>
      Theme.of(context).extension<AppTextStyles>()!;

  // ── Dark ──
  static final dark = AppTextStyles(
    hero: TextStyle(
      fontFamily: AppColors.fontBody,
      fontSize: 56,
      fontWeight: FontWeight.w700,
      color: AppColors.dark.textPrimary,
      height: 1.08,
      letterSpacing: -0.8,
    ),
    sectionTitle: TextStyle(
      fontFamily: AppColors.fontBody,
      fontSize: 36,
      fontWeight: FontWeight.w700,
      color: AppColors.dark.textPrimary,
      height: 1.15,
      letterSpacing: -0.5,
    ),
    sectionLabel: TextStyle(
      fontFamily: AppColors.fontBody,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.dark.accent,
      letterSpacing: 2.0,
    ),
    cardTitle: TextStyle(
      fontFamily: AppColors.fontBody,
      fontSize: 17,
      fontWeight: FontWeight.w600,
      color: AppColors.dark.textPrimary,
    ),
    body: TextStyle(
      fontFamily: AppColors.fontBody,
      fontSize: 15,
      fontWeight: FontWeight.w300,
      color: AppColors.dark.textSecondary,
      height: 1.7,
    ),
    caption: TextStyle(
      fontFamily: AppColors.fontBody,
      fontSize: 13,
      fontWeight: FontWeight.w300,
      color: AppColors.dark.textSecondary,
    ),
  );

  // ── Light ──
  static final light = AppTextStyles(
    hero: TextStyle(
      fontFamily: AppColors.fontBody,
      fontSize: 56,
      fontWeight: FontWeight.w700,
      color: AppColors.light.textPrimary,
      height: 1.08,
      letterSpacing: -0.8,
    ),
    sectionTitle: TextStyle(
      fontFamily: AppColors.fontBody,
      fontSize: 36,
      fontWeight: FontWeight.w700,
      color: AppColors.light.textPrimary,
      height: 1.15,
      letterSpacing: -0.5,
    ),
    sectionLabel: TextStyle(
      fontFamily: AppColors.fontBody,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.light.accent,
      letterSpacing: 2.0,
    ),
    cardTitle: TextStyle(
      fontFamily: AppColors.fontBody,
      fontSize: 17,
      fontWeight: FontWeight.w600,
      color: AppColors.light.textPrimary,
    ),
    body: TextStyle(
      fontFamily: AppColors.fontBody,
      fontSize: 15,
      fontWeight: FontWeight.w400,       // w300 jest za cienkie na jasnym tle
      color: AppColors.light.textSecondary,
      height: 1.7,
    ),
    caption: TextStyle(
      fontFamily: AppColors.fontBody,
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: AppColors.light.textMuted,
    ),
  );

  @override
  AppTextStyles copyWith({
    TextStyle? hero,
    TextStyle? sectionTitle,
    TextStyle? sectionLabel,
    TextStyle? cardTitle,
    TextStyle? body,
    TextStyle? caption,
  }) {
    return AppTextStyles(
      hero: hero ?? this.hero,
      sectionTitle: sectionTitle ?? this.sectionTitle,
      sectionLabel: sectionLabel ?? this.sectionLabel,
      cardTitle: cardTitle ?? this.cardTitle,
      body: body ?? this.body,
      caption: caption ?? this.caption,
    );
  }

  @override
  AppTextStyles lerp(AppTextStyles? other, double t) {
    if (other is! AppTextStyles) return this;
    return AppTextStyles(
      hero: TextStyle.lerp(hero, other.hero, t)!,
      sectionTitle: TextStyle.lerp(sectionTitle, other.sectionTitle, t)!,
      sectionLabel: TextStyle.lerp(sectionLabel, other.sectionLabel, t)!,
      cardTitle: TextStyle.lerp(cardTitle, other.cardTitle, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
    );
  }
}