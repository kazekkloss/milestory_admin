import 'package:flutter/material.dart';

class CustomExpansionTileTheme {
  CustomExpansionTileTheme._();

  static final expansionTile = ExpansionTileThemeData(
    backgroundColor: const Color.fromARGB(255, 49, 49, 49),
    collapsedBackgroundColor: const Color.fromARGB(255, 49, 49, 49),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide.none),
    collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide.none),
    childrenPadding: EdgeInsets.zero,
  );
}
