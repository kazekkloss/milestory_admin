import 'package:flutter/material.dart';
import '../core_export.dart';

class CustomTheme {
  CustomTheme._();

  // this is main app theme
  static ThemeData theme = ThemeData(
    colorScheme: CustomColorScheme.customColorScheme,
    splashFactory: NoSplash.splashFactory,
    unselectedWidgetColor: CustomColorScheme.customColorScheme.primary,
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
    appBarTheme: CustomAppBarTheme.appBarTheme,
    textTheme: CustomTextTheme.textTheme,
    elevatedButtonTheme: CustomElevatedButtonTheme.elevatedButtonTheme,
    outlinedButtonTheme: CustomOutlinedButtonTheme.elevatedButtonTheme,
    inputDecorationTheme: CustomInputDecorationTheme.inputDecotationTheme,
    tabBarTheme: CustomTabBarTheme.tabBarTheme,
    navigationRailTheme: CustomNavRailTheme.navRailTheme,
    floatingActionButtonTheme: CustomFloatingActionButtonTheme.elevatedButtonTheme,
    drawerTheme: CustomDrawerTheme.drawerTheme,
    iconTheme: const IconThemeData(color: Colors.black),
    sliderTheme: CustomSliderTheme.sliderTheme,
    expansionTileTheme: CustomExpansionTileTheme.expansionTile,
    dialogTheme: CustomDialogTheme.dialogTheme,
    listTileTheme: CustomListTileTheme.listTile,
    snackBarTheme: CustomSnackBarTheme.snackBarTheme,
    dropdownMenuTheme: CustomDropdownMenuTheme.dropdownMenuTheme,
  );

  // // this theme is only for license screen
  // static ThemeData licenseTheme = theme.copyWith(
  //   scaffoldBackgroundColor: CustomColorScheme.customColorScheme.onPrimary,
  //   appBarTheme: AppBarTheme(
  //     centerTitle: true,
  //     titleTextStyle: CustomTextTheme.textTheme.headlineMedium!.copyWith(color: CustomColorScheme.customColorScheme.primary),
  //     iconTheme: IconThemeData(color: CustomColorScheme.customColorScheme.primary),
  //     backgroundColor: CustomColorScheme.customColorScheme.onPrimary,
  //     shadowColor: CustomColorScheme.customColorScheme.onPrimary,
  //     surfaceTintColor: CustomColorScheme.customColorScheme.onPrimary,
  //   ),
  //   cardColor: CustomColorScheme.customColorScheme.onPrimary,
  //   textTheme: TextTheme(bodyMedium: CustomTextTheme.textTheme.labelMedium!),
  //   listTileTheme: ListTileThemeData(
  //     tileColor: CustomColorScheme.customColorScheme.onPrimary,
  //     titleTextStyle: CustomTextTheme.textTheme.titleMedium!,
  //     subtitleTextStyle: CustomTextTheme.textTheme.labelMedium!,
  //   ),
  //   iconTheme: const IconThemeData(color: Colors.white70),
  // );
}
