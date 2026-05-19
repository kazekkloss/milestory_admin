import 'package:flutter/material.dart';

import 'colors.dart';

class CustomMenuTheme {
  CustomMenuTheme._();

  static MenuStyle build(AppColors colors) {
    return MenuStyle(
      backgroundColor: WidgetStateProperty.all(colors.bgCard),
      surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
      elevation: WidgetStateProperty.all(4.0),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(colors.radiusSm),
          side: BorderSide(
            color: colors.accentBorder,
            width: 0.5,
          ),
        ),
      ),
    );
  }
}
