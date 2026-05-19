// lib/core/theme/dropdown_menu.dart

import 'package:flutter/material.dart';

import 'colors.dart';

class CustomDropdownMenuTheme {
  CustomDropdownMenuTheme._();

  static DropdownMenuThemeData build(AppColors colors) {
    return DropdownMenuThemeData(
      textStyle: TextStyle(
        fontFamily: AppColors.fontBody,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: colors.textPrimary,
      ),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(colors.bgCard),
        surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
        elevation: WidgetStateProperty.all(4),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            side: BorderSide(color: colors.accentBorder, width: 0.5),
            borderRadius: BorderRadius.circular(colors.radiusSm),
          ),
        ),
      ),
    );
  }
}
