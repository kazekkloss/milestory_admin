import 'package:flutter/material.dart';

import 'colors.dart';

class CustomSwitchTheme {
  CustomSwitchTheme._();

  static SwitchThemeData build(AppColors colors) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return colors.accent;
        return colors.textMuted;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colors.accent.withValues(alpha: 0.4);
        }
        return colors.bgInput;
      }),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      overlayColor: WidgetStateProperty.all(Colors.transparent),
    );
  }
}