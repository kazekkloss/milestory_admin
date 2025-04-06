import 'package:flutter/material.dart';
import 'package:milestory_crm/core/core_export.dart';

class CustomElevatedButtonTheme {
  CustomElevatedButtonTheme._();

  static final elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      disabledBackgroundColor: CustomColorScheme.customColorScheme.primary,
      shadowColor: Colors.transparent,
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}
