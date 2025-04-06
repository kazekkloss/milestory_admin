import 'package:flutter/material.dart';

class CustomDialogTheme {
  CustomDialogTheme._();

  static const dialogTheme = DialogThemeData(
    backgroundColor: Color.fromARGB(255, 49, 49, 49),
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Color.fromARGB(255, 177, 203, 243), width: 1),
      borderRadius: BorderRadius.all(Radius.circular(14)),
    ),
  );
}
