import 'package:flutter/material.dart';

import 'colors.dart';

class CustomOutlinedButtonTheme {
  CustomOutlinedButtonTheme._();

  static OutlinedButtonThemeData build(AppColors colors) {
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        // ── Hight / padding ──
        minimumSize: const WidgetStatePropertyAll(Size(0, 34)),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 16),
        ),

        // ── Shape: rounded corners = radiusSm ──
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(colors.radiusSm),
          ),
        ),

        // ── Text: 12px, weight 500 ──
        textStyle: const WidgetStatePropertyAll(
          TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),

        // ── Text/icon color — depending on condition ──
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return colors.textMuted;
          return colors.accent;
        }),

        // ── Background — depending on condition ──
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return colors.bgCard;
          if (states.contains(WidgetState.hovered)) {
            return colors.accent.withValues(alpha: 0.15);
          }
          return colors.accent.withValues(alpha: 0.08);
        }),

        // ── Border — depending on condition ──
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return BorderSide(color: colors.borderSubtle, width: 0.5);
          }
          if (states.contains(WidgetState.hovered)) {
            return BorderSide(
                color: colors.accent.withValues(alpha: 0.6), width: 0.5);
          }
          return BorderSide(
              color: colors.accent.withValues(alpha: 0.35), width: 0.5);
        }),

        // ── Overlay (ripple) ──
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return colors.accent.withValues(alpha: 0.1);
          }
          return Colors.transparent;
        }),

        // ── Mouse cursor — forbidden gdy disabled ──
        mouseCursor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return SystemMouseCursors.forbidden;
          }
          return SystemMouseCursors.click;
        }),

        // ── Elevation, animation duration ──
        elevation: const WidgetStatePropertyAll(0),
        animationDuration: const Duration(milliseconds: 150),
      ),
    );
  }
}