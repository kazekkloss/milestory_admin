import 'package:flutter/material.dart';
import 'package:milestory_crm/core/core_export.dart';

class CustomListTileTheme {
  CustomListTileTheme._();

  static final listTile = ListTileThemeData(
    contentPadding: const EdgeInsets.only(left: 16, right: 9),
    iconColor: CustomColorScheme.customColorScheme.primary,
    horizontalTitleGap: 10,
    tileColor: const Color.fromARGB(255, 49, 49, 49),
    titleTextStyle: CustomTextTheme.textTheme.labelMedium!,
    subtitleTextStyle: CustomTextTheme.textTheme.labelSmall!,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14.0),
    ),
  );
}