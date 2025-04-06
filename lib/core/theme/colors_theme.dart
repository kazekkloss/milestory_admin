import 'package:flutter/material.dart';

class CustomColorScheme {
  CustomColorScheme._();

  static const customColorScheme =  ColorScheme(
    brightness: Brightness.dark,
    primary: Color.fromARGB(255, 177, 203, 243),
    onPrimary: Color.fromARGB(255, 0, 0, 0),
    onPrimaryContainer: Colors.white,
    secondary: Color.fromARGB(255, 255, 255, 255),
    onSecondary: Colors.transparent,
    error: Color.fromARGB(255, 255, 0, 0),
    onError: Color.fromARGB(255, 255, 0, 0),
    surface:  Color.fromARGB(255, 177, 203, 243),
    onSurface: Color.fromARGB(255, 255, 255, 255),
    outline: Color.fromARGB(255, 177, 203, 243),
  );
}
