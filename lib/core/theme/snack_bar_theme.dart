import 'package:flutter/material.dart';

class CustomSnackBarTheme {
  CustomSnackBarTheme._();

  static final snackBarTheme = SnackBarThemeData(
    backgroundColor: const Color.fromARGB(255, 49, 49, 49),
    behavior: SnackBarBehavior.floating,
    elevation: 4.0,
    shape: RoundedRectangleBorder(
      side: const BorderSide(color: Color.fromARGB(255, 177, 203, 243), width: 1),
      borderRadius: BorderRadius.circular(14),
    ),
    contentTextStyle: const TextStyle(
      color: Colors.black,
      fontSize: 14,
    ),
  );
}
