import 'package:flutter/material.dart';

/// Semantic colors used throughout the app for states: success, warning,
/// info, danger. Single source of truth — do not duplicate these hex values
/// anywhere else.
class SemanticColors {
  SemanticColors._();

  static const success = Color(0xFF1D9E75); // green: done, public
  static const warning = Color(0xFFEF9F27); // orange: verify, pending
  static const info = Color(0xFF378ADD); // blue: hint, edited
  static const infoLight =
      Color(0xFF85B7EB); // lighter blue (title on bg)
  static const danger = Color(0xFFE24B4A); // red: delete, error

  // ── Backgrounds (dark bg under icons in hints, mode headers) ──
  static const successBg = Color(0xFF031410);
  static const warningBg = Color(0xFF2D1E00);
  static const infoBg = Color(0xFF041525);

  // ── Extra colors for "New tour" mode header ──
  static const infoBorder = Color(0xFF0D2A45);
  static const infoIconBg = Color(0xFF0C2A4A);
}
