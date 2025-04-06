import 'package:flutter/material.dart';
import 'package:milestory_crm/core/theme/colors_theme.dart';
import 'package:milestory_crm/core/utils/size_extensions.dart';

class CustomDrawerTheme {
  CustomDrawerTheme._();

  static final drawerTheme = DrawerThemeData(
    scrimColor: Colors.transparent,
    width: 100.w,
    backgroundColor: CustomColorScheme.customColorScheme.onPrimary,
  );
}
