// lib/features/creator/presentation/map/map_style.dart

import 'package:flutter/material.dart';

/// Stałe stylu mapy — tylko rzeczy niezależne od palety (kolor dynamicznie
/// czerpiemy z AppColors przez MapBuilders).
class MapStyle {
  MapStyle._();

  // Polygon — fill alpha
  static const double areaFillAlpha = 0.60;
  static const double areaFillAlphaSelected = 0.60;

  // Polyline (linia rysowania nowego obszaru)
  static const int polylineWidth = 3;

  // Marker pierwszy
  static const String firstMarkerAsset = 'assets/images/marker_milestory.png';
  static const Size firstMarkerSize = Size(30, 30);

  // Kolor akcentu wybranego obszaru — pomarańczowy
  // (nie jest w AppColors bo to specyficzne dla mapy)
  static const Color selectedColor = Color(0xFFEF9F27);
}