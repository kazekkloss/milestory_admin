import 'package:flutter/material.dart';

class CustomInputDecorationTheme {
  CustomInputDecorationTheme._();

  static final inputDecotationTheme = InputDecorationTheme(
    filled: true,
    fillColor: const Color.fromARGB(255, 49, 49, 49),
    hintStyle: const TextStyle(fontSize: 14, color: Color.fromARGB(160, 255, 255, 255), fontWeight: FontWeight.w300),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(
        width: 1,
        color: Color.fromARGB(255, 49, 49, 49),
      ),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: Color.fromARGB(255, 49, 49, 49)),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: Color.fromARGB(255, 255, 255, 255)),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: Color.fromARGB(255, 255, 0, 0)),
    ),
    //focusedErrorBorder:
    //    const OutlineInputBorder().copyWith(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(width: 1, color: Colors.green)),
    errorMaxLines: 1,
    errorStyle: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: Color.fromARGB(255, 255, 0, 0)),
  );
}