import 'package:flutter/material.dart';

class CustomNavBarTheme {
  CustomNavBarTheme._();

  static const navBarTheme = BottomNavigationBarThemeData(
    backgroundColor: Colors.transparent,
    showSelectedLabels: false,
    showUnselectedLabels: false,
    selectedIconTheme: IconThemeData(size: 30),
    unselectedIconTheme: IconThemeData(size: 20),
  );
}
