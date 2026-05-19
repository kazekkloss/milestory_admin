import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../creator_export.dart';

Area createArea({
  required List<TourPoint> tourPoints,
  required List<LatLng> points,
}) {
  final allAreas = tourPoints.expand((p) => p.areas).toList();
  final maxId = allAreas.isNotEmpty
      ? allAreas.map((a) => int.tryParse(a.id) ?? 0).reduce(max)
      : 0;

  return Area(
    id: (maxId + 1).toString(),
    latLng: points,
    direction: null,
  );
}

List<TourPoint> addAreaToTourPoints({
  required List<TourPoint> tourPoints,
  required Area area,
  int? addToPointId,
}) {
  final updated = List<TourPoint>.from(tourPoints);
  if (addToPointId != null) {
    final index = updated.indexWhere((p) => p.id == addToPointId);
    if (index != -1) {
      final areas = List<Area>.from(updated[index].areas)..add(area);
      updated[index] = updated[index].copyWith(areas: areas);
    }
  } else {
    updated.add(TourPoint(
      id: updated.length,
      title: null,
      description: null,
      areas: [area],
    ));
  }
  return updated;
}

List<TourPoint> updateAreaDirection({
  required List<TourPoint> tourPoints,
  required String areaId,
  required double? direction,
}) {
  return tourPoints
      .map((tp) => tp.copyWith(
            areas: tp.areas
                .map((a) =>
                    a.id == areaId ? a.copyWith(direction: direction) : a)
                .toList(),
          ))
      .toList();
}

List<TourPoint> removeAreaFromTourPoints({
  required List<TourPoint> tourPoints,
  required String areaId,
}) {
  return tourPoints
      .map((tp) =>
          tp.copyWith(areas: tp.areas.where((a) => a.id != areaId).toList()))
      .toList();
}