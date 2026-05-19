import 'package:flutter/widgets.dart';

extension SizeExtension on num {
  double get h => SizeConfig.screenHeightPercentage(this);
  double get w => SizeConfig.screenWidthPercentage(this);
  double get sp => SizeConfig.screenTextScale(this);
}

class SizeConfig {
  static double screenWidthPercentage(num percentage) {
    final context = SizeConfig._context;
    if (context == null) {
      throw Exception('SizeConfig context has not been set.');
    }
    return MediaQuery.sizeOf(context).width * (percentage / 100);
  }

  static double screenHeightPercentage(num percentage) {
    final context = SizeConfig._context;
    if (context == null) {
      throw Exception('SizeConfig context has not been set.');
    }
    return MediaQuery.sizeOf(context).height * (percentage / 100);
  }

  static double screenTextScale(num fontSize) {
    final context = SizeConfig._context;
    if (context == null) {
      throw Exception('SizeConfig context has not been set.');
    }
    return (fontSize / 100) * MediaQuery.sizeOf(context).width;
  }

  /// < 900px — single-column layouts, stacked cards
  static bool isNarrow(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 900;

  /// < 600px — phone-sized, tighter padding
  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 600;

  /// >= 1200px — extra-wide
  static bool isWide(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 1200;

  static BuildContext? _context;

  static void init(BuildContext context) {
    _context = context;
  }

  static const double sidePanelWidth = 360;
  static const double authFormHeight = 560;
  static const double kPillWidth = 120.0;
}
