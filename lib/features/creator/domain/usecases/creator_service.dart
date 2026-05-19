import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

import '../../creator_export.dart';

@lazySingleton
class CreatorService {
  // ========================= VALIDATION =========================

  String? getAreaIdIfPointInside({
    required LatLng point,
    required Set<Polygon> polygons,
  }) {
    for (final p in polygons) {
      if (p.points.length < 3) continue;
      if (_isPointInPolygon(point, p.points)) return p.polygonId.value;
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
      if (_doesLineIntersectPolygon(last, newPoint, polygon.points)) {
        return false;
      }
    }
    return true;
  }

  /// Prevents self-intersecting (hourglass, star, etc.)
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
      if (_doLinesIntersect(start, end, a, b)) return true;
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
        if (_isPointInPolygon(p, exPoints)) return true;
      }
      for (final p in exPoints) {
        if (_isPointInPolygon(p, newPoints)) return true;
      }
      if (_doesLineIntersectPolygonList(newPoints, exPoints)) return true;
    }
    return false;
  }

  // ========================= GEOMETRY =========================
  bool _isPointInPolygon(LatLng point, List<LatLng> polygon) {
    int intersections = 0;
    for (int i = 0; i < polygon.length; i++) {
      final j = (i + 1) % polygon.length;
      final a = polygon[i];
      final b = polygon[j];

      if ((a.latitude > point.latitude) != (b.latitude > point.latitude) &&
          (point.longitude <
              (b.longitude - a.longitude) *
                      (point.latitude - a.latitude) /
                      (b.latitude - a.latitude == 0
                          ? 0.0000001
                          : b.latitude - a.latitude) +
                  a.longitude)) {
        intersections++;
      }
    }
    return intersections % 2 == 1;
  }

  bool _doesLineIntersectPolygon(LatLng p1, LatLng p2, List<LatLng> polygon) {
    for (int i = 0; i < polygon.length; i++) {
      if (_doLinesIntersect(
          p1, p2, polygon[i], polygon[(i + 1) % polygon.length])) {
        return true;
      }
    }
    return false;
  }

  bool _doesLineIntersectPolygonList(List<LatLng> poly1, List<LatLng> poly2) {
    for (int i = 0; i < poly1.length; i++) {
      for (int j = 0; j < poly2.length; j++) {
        if (_doLinesIntersect(
          poly1[i],
          poly1[(i + 1) % poly1.length],
          poly2[j],
          poly2[(j + 1) % poly2.length],
        )) {
          return true;
        }
      }
    }
    return false;
  }

  bool _doLinesIntersect(LatLng p1, LatLng p2, LatLng q1, LatLng q2) {
    double cross(LatLng a, LatLng b, LatLng c) =>
        (b.longitude - a.longitude) * (c.latitude - a.latitude) -
        (b.latitude - a.latitude) * (c.longitude - a.longitude);

    final d1 = cross(p1, p2, q1);
    final d2 = cross(p1, p2, q2);
    final d3 = cross(q1, q2, p1);
    final d4 = cross(q1, q2, p2);

    if (((d1 > 0 && d2 < 0) || (d1 < 0 && d2 > 0)) &&
        ((d3 > 0 && d4 < 0) || (d3 < 0 && d4 > 0))) {
      return true;
    }

    if (d1 == 0 && _onSegment(p1, p2, q1)) return true;
    if (d2 == 0 && _onSegment(p1, p2, q2)) return true;
    if (d3 == 0 && _onSegment(q1, q2, p1)) return true;
    if (d4 == 0 && _onSegment(q1, q2, p2)) return true;

    return false;
  }

  bool _onSegment(LatLng p, LatLng q, LatLng r) {
    return r.longitude <= max(p.longitude, q.longitude) &&
        r.longitude >= min(p.longitude, q.longitude) &&
        r.latitude <= max(p.latitude, q.latitude) &&
        r.latitude >= min(p.latitude, q.latitude);
  }

  // ========================= BUILDERS =========================
  Future<Marker> createMarker({
    required int index,
    required LatLng position,
    required bool isFirst,
    required VoidCallback onTap,
  }) async {
    final BitmapDescriptor icon = isFirst
        ? await BitmapDescriptor.asset(
            const ImageConfiguration(size: Size(30, 30)),
            'assets/images/marker_milestory.png',
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
  }) =>
      Polyline(
        polylineId: PolylineId(index.toString()),
        points: points,
        color: Colors.blue,
        width: 2,
      );

  Polygon createPolygon({
    required Area area,
    required VoidCallback onTap,
  }) =>
      Polygon(
        polygonId: PolygonId(area.id),
        points: area.latLng,
        strokeWidth: 2,
        strokeColor: Colors.blue,
        fillColor: Colors.blue.withValues(alpha: 0.3),
        onTap: onTap,
      );

  // ========================= DOMAIN =========================
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
          id: updated.length, title: null, description: null, areas: [area]));
    }
    return updated;
  }

  List<TourPoint> updateDirection({
    required List<TourPoint> tourPoints,
    required String areaId,
    required double? direction,
  }) =>
      tourPoints
          .map((tp) => tp.copyWith(
                areas: tp.areas
                    .map((a) =>
                        a.id == areaId ? a.copyWith(direction: direction) : a)
                    .toList(),
              ))
          .toList();

  List<TourPoint> removeArea({
    required List<TourPoint> tourPoints,
    required String areaId,
  }) =>
      tourPoints
          .map((tp) => tp.copyWith(
              areas: tp.areas.where((a) => a.id != areaId).toList()))
          .toList();

  Set<Polygon> updateSelection({
    required Set<Polygon> polygons,
    required String? selectedId,
  }) =>
      polygons
          .map((p) => p.copyWith(
                fillColorParam: p.polygonId.value == selectedId
                    ? Colors.red.withValues(alpha: 0.3)
                    : Colors.blue.withValues(alpha: 0.3),
                strokeColorParam:
                    p.polygonId.value == selectedId ? Colors.red : Colors.blue,
              ))
          .toSet();

  // ========================= GEOMETRY =========================

  LatLng? getPolygonCenter(List<LatLng> points) {
    if (points.length < 3) return null;

    double sumLat = 0;
    double sumLng = 0;

    for (final point in points) {
      sumLat += point.latitude;
      sumLng += point.longitude;
    }

    return LatLng(
      sumLat / points.length,
      sumLng / points.length,
    );
  }
}
