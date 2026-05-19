import 'package:flutter/material.dart';

import 'colors.dart';

class CustomExpansionTileTheme {
  CustomExpansionTileTheme._();

  static ExpansionTileThemeData build(AppColors colors) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(colors.radiusMd),
      side: BorderSide.none,
    );

    return ExpansionTileThemeData(
      backgroundColor: colors.bgInput,
      collapsedBackgroundColor: colors.bgInput,
      shape: shape,
      collapsedShape: shape,
      childrenPadding: EdgeInsets.zero,
      iconColor: colors.textSecondary,
      collapsedIconColor: colors.textSecondary,
      textColor: colors.textPrimary,
      collapsedTextColor: colors.textPrimary,
    );
  }
}