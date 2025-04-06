import 'package:flutter/material.dart';
import 'package:milestory_crm/core/core_export.dart';

class CustomSliderTheme {
  CustomSliderTheme._();

  static final sliderTheme = SliderThemeData(
    trackHeight: 5,
    activeTrackColor: CustomColorScheme.customColorScheme.primary,
    inactiveTrackColor: const Color.fromARGB(255, 255, 255, 255),
    thumbShape: SliderComponentShape.noThumb,
  );
}
