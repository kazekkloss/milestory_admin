// lib/features/creator/domain/logic/area_validators.dart

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'geometry_utils.dart';

String? getAreaIdIfPointInside({
  required LatLng point,
  required Set<Polygon> polygons,
}) {
  for (final p in polygons) {
    if (p.points.length < 3) continue;
    if (isPointInPolygon(point, p.points)) return p.polygonId.value;
  }
  return null;
}

bool canAddSegment({
  required LatLng newPoint,
  required List<Marker> markers,
  required Set<Polygon> polygons,
}) {
  if (markers.isEmpty) return true;
  final last = markers.last.position;
  for (final polygon in polygons) {
    if (doesLineIntersectPolygon(last, newPoint, polygon.points)) {
      return false;
    }
  }
  return true;
}

bool doesSegmentIntersectCurrentDrawing({
  required LatLng newPoint,
  required List<Marker> markers,
}) {
  if (markers.length < 2) return false;

  final start = markers.last.position;
  final end = newPoint;

  for (int i = 0; i < markers.length - 2; i++) {
    final a = markers[i].position;
    final b = markers[i + 1].position;
    if (doLinesIntersect(start, end, a, b)) return true;
  }
  return false;
}

bool doesNewAreaOverlap({
  required List<LatLng> newPoints,
  required Set<Polygon> existingPolygons,
}) {
  if (newPoints.length < 3) return false;

  for (final existing in existingPolygons) {
    final exPoints = existing.points;

    for (final p in newPoints) {
      if (isPointInPolygon(p, exPoints)) return true;
    }
    for (final p in exPoints) {
      if (isPointInPolygon(p, newPoints)) return true;
    }
    if (doPolygonsIntersect(newPoints, exPoints)) return true;
  }
  return false;
}