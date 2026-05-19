import 'package:flutter/material.dart';

/// Custom color/design tokens accessible via:
///   `Theme.of(context).extension<AppColors>()!`
///   or the shortcut: `AppColors.of(context)`
///
/// Single source of truth — no duplicates anywhere in the app.
class AppColors extends ThemeExtension<AppColors> {
  // ── Accent palette ──
  final Color accent;
  final Color accentDim;
  final Color accentBorder;
  final Color accentGlow;

  // ── Backgrounds ──
  final Color bg;
  final Color bgCard;
  final Color bgCardHover;
  final Color bgElevated;
  final Color bgInput;

  // ── Text ──
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;

  // ── Semantic ──
  final Color error;
  final Color borderSubtle;
  final Color dangerColor;

  // ── Radii ──
  final double radiusSm;
  final double radiusMd;
  final double radiusLg;

  const AppColors({
    required this.accent,
    required this.accentDim,
    required this.accentBorder,
    required this.accentGlow,
    required this.bg,
    required this.bgCard,
    required this.bgCardHover,
    required this.bgElevated,
    required this.bgInput,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.error,
    required this.borderSubtle,
    required this.dangerColor,
    required this.radiusSm,
    required this.radiusMd,
    required this.radiusLg,
  });

  /// Shortcut: `AppColors.of(context)` instead of `Theme.of(context).extension<AppColors>()!`
  static AppColors of(BuildContext context) =>
      Theme.of(context).extension<AppColors>()!;

  // ── Dark theme ──
  static const dark = AppColors(
    accent: Color(0xFFB1CBF3),
    accentDim: Color(0x1AB1CBF3),
    accentBorder: Color(0x40B1CBF3),
    accentGlow: Color(0x40B1CBF3),
    bg: Color(0xFF000000),
    bgCard: Color(0xFF0A0A0A),
    bgCardHover: Color(0xFF0F0F0F),
    bgElevated: Color(0xFF181818),
    bgInput: Color(0xFF393939),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFF999999),
    textMuted: Color(0xFF666666),
    error: Color(0xFFFF4444),
    dangerColor: Color(0xFFE24B4A),
    borderSubtle: Color(0xFF3D3D3D),
    radiusSm: 10,
    radiusMd: 16,
    radiusLg: 22,
  );

  // ── Light theme ──
  static const light = AppColors(
    accent: Color(0xFFB1CBF3),
    accentDim: Color(0x1A2E6AB8),
    accentBorder: Color(0x262E6AB8),
    accentGlow: Color(0x402E6AB8),
    bg: Color(0xFFF7F8FA),
    bgCard: Color(0xFFFFFFFF),
    bgCardHover: Color(0xFFF0F2F5),
    bgElevated: Color(0xFFF2F3F6),
    bgInput: Color(0xFFEBEDF0),
    textPrimary: Color(0xFF111111),
    textSecondary: Color(0xFF5A5A5A),
    textMuted: Color(0xFF999999),
    error: Color(0xFFD32F2F),
    dangerColor: Color(0xFFE24B4A),
    borderSubtle: Color(0xFF3D3D3D),
    radiusSm: 10,
    radiusMd: 16,
    radiusLg: 22,
  );

  // ── Font families (static, don't need lerp) ──
  static const String fontBody = 'Poppins';
  static const String fontDisplay = 'Tajawal';

  @override
  AppColors copyWith({
    Color? accent,
    Color? accentDim,
    Color? accentBorder,
    Color? accentGlow,
    Color? bg,
    Color? bgCard,
    Color? bgCardHover,
    Color? bgElevated,
    Color? bgInput,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? error,
    Color? dangerColor,
    Color? borderSubtle,
    double? radiusSm,
    double? radiusMd,
    double? radiusLg,
  }) {
    return AppColors(
      accent: accent ?? this.accent,
      accentDim: accentDim ?? this.accentDim,
      accentBorder: accentBorder ?? this.accentBorder,
      accentGlow: accentGlow ?? this.accentGlow,
      bg: bg ?? this.bg,
      bgCard: bgCard ?? this.bgCard,
      bgCardHover: bgCardHover ?? this.bgCardHover,
      bgElevated: bgElevated ?? this.bgElevated,
      bgInput: bgInput ?? this.bgInput,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      error: error ?? this.error,
      dangerColor: dangerColor ?? this.dangerColor,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      radiusSm: radiusSm ?? this.radiusSm,
      radiusMd: radiusMd ?? this.radiusMd,
      radiusLg: radiusLg ?? this.radiusLg,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      accent: Color.lerp(accent, other.accent, t)!,
      accentDim: Color.lerp(accentDim, other.accentDim, t)!,
      accentBorder: Color.lerp(accentBorder, other.accentBorder, t)!,
      accentGlow: Color.lerp(accentGlow, other.accentGlow, t)!,
      bg: Color.lerp(bg, other.bg, t)!,
      bgCard: Color.lerp(bgCard, other.bgCard, t)!,
      bgCardHover: Color.lerp(bgCardHover, other.bgCardHover, t)!,
      bgElevated: Color.lerp(bgElevated, other.bgElevated, t)!,
      bgInput: Color.lerp(bgInput, other.bgInput, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      error: Color.lerp(error, other.error, t)!,
      dangerColor: Color.lerp(dangerColor, other.dangerColor, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      radiusSm: lerpDouble(radiusSm, other.radiusSm, t)!,
      radiusMd: lerpDouble(radiusMd, other.radiusMd, t)!,
      radiusLg: lerpDouble(radiusLg, other.radiusLg, t)!,
    );
  }
}

double? lerpDouble(double a, double b, double t) => a + (b - a) * t;
