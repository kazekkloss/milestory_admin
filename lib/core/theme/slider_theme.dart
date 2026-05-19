import 'package:flutter/material.dart';

import 'colors.dart';

class CustomSliderTheme {
  CustomSliderTheme._();

  static SliderThemeData build(AppColors colors) {
    return SliderThemeData(
      trackHeight: 5,
      activeTrackColor: colors.accent,
      inactiveTrackColor: colors.bgInput,
      thumbShape: SliderComponentShape.noThumb,
      overlayShape: SliderComponentShape.noOverlay,
    );
  }
}