import 'package:flutter/material.dart';
import '../core_export.dart';

class CustomDropdownMenuTheme {
  CustomDropdownMenuTheme._();

  static final dropdownMenuTheme = DropdownMenuThemeData(
    textStyle: CustomTextTheme.textTheme.labelMedium!,
    menuStyle: MenuStyle(backgroundColor: WidgetStateProperty.all(CustomColorScheme.customColorScheme.onPrimary)),
  );
}
