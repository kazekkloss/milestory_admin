import 'package:flutter/material.dart';
import 'package:milestory_crm/core/theme/colors_theme.dart';

class CustomAppBarTheme {
  CustomAppBarTheme._();

  static final appBarTheme = AppBarTheme(
      titleTextStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
      centerTitle: true,
      backgroundColor: CustomColorScheme.customColorScheme.primary,
      surfaceTintColor: Colors.transparent,);
}
