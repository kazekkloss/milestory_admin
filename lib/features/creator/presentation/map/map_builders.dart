// lib/features/creator/presentation/map/map_builders.dart

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

import '../../creator_export.dart';

@lazySingleton
class MapBuilders {
  Future<Marker> createMarker({
    required int index,
    required LatLng position,
    required bool isFirst,
    required VoidCallback onTap,
  }) async {
    final BitmapDescriptor icon = isFirst
        ? await BitmapDescriptor.asset(
            const ImageConfiguration(size: MapStyle.firstMarkerSize),
            MapStyle.firstMarkerAsset,
          )
        : BitmapDescriptor.defaultMarker;

    return Marker(
      markerId: MarkerId(index.toString()),
      position: position,
      icon: icon,
      visible: isFirst,
      onTap: onTap,
      anchor: const Offset(0.5, 0.5),
    );
  }

  Polyline createPolyline({
    required int index,
    required List<LatLng> points,
  }) {
    return Polyline(
      polylineId: PolylineId(index.toString()),
      points: points,
      // Polyline is only when drawing - always orange.
      color: MapStyle.selectedColor,
      width: MapStyle.polylineWidth,
    );
  }

  /// Creates a polygon. `accentColor` = color of the unselected area (from AppColors).
  Polygon createPolygon({
    required Area area,
    required VoidCallback onTap,
    required Color accentColor,
  }) {
    return Polygon(
      polygonId: PolygonId(area.id),
      points: area.latLng,
      strokeWidth: 0,
      strokeColor: Colors.transparent,
      fillColor: accentColor.withValues(alpha: MapStyle.areaFillAlpha),
      onTap: onTap,
    );
  }

  /// Updates polygon colors based on selection.
  /// - selected: orange fill
  /// - unselected: accent fill (from AppColors)
  Set<Polygon> updateSelection({
    required Set<Polygon> polygons,
    required String? selectedId,
    required Color accentColor,
  }) {
    return polygons.map((p) {
      final isSelected = p.polygonId.value == selectedId;
      return p.copyWith(
        fillColorParam: isSelected
            ? MapStyle.selectedColor
                .withValues(alpha: MapStyle.areaFillAlphaSelected)
            : accentColor.withValues(alpha: MapStyle.areaFillAlpha),
        strokeColorParam: Colors.transparent,
        strokeWidthParam: 0,
      );
    }).toSet();
  }
}
