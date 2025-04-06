import 'package:flutter/material.dart';

class CustomOutlinedButtonTheme {
  CustomOutlinedButtonTheme._();

  static final elevatedButtonTheme = OutlinedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: const Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}
