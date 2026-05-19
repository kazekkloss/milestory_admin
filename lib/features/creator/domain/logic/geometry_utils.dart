import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Pure geometry helpers. No Flutter widget dependencies.
/// All functions are top-level and stateless.

/// Point-in-polygon test (ray casting algorithm).
/// Correctly ignores horizontal edges (divide-by-zero).
bool isPointInPolygon(LatLng point, List<LatLng> polygon) {
  int intersections = 0;
  for (int i = 0; i < polygon.length; i++) {
    final j = (i + 1) % polygon.length;
    final a = polygon[i];
    final b = polygon[j];

    // Skip horizontal edges — ray casting does not touch them.
    if (a.latitude == b.latitude) continue;

    final crosses =
        (a.latitude > point.latitude) != (b.latitude > point.latitude);
    if (!crosses) continue;

    final intersectLng = (b.longitude - a.longitude) *
            (point.latitude - a.latitude) /
            (b.latitude - a.latitude) +
        a.longitude;

    if (point.longitude < intersectLng) {
      intersections++;
    }
  }
  return intersections % 2 == 1;
}

/// Checks whether segment p1-p2 intersects any edge of the polygon.
bool doesLineIntersectPolygon(LatLng p1, LatLng p2, List<LatLng> polygon) {
  for (int i = 0; i < polygon.length; i++) {
    if (doLinesIntersect(
        p1, p2, polygon[i], polygon[(i + 1) % polygon.length])) {
      return true;
    }
  }
  return false;
}

/// Checks whether any edge of poly1 intersects any edge of poly2.
bool doPolygonsIntersect(List<LatLng> poly1, List<LatLng> poly2) {
  for (int i = 0; i < poly1.length; i++) {
    for (int j = 0; j < poly2.length; j++) {
      if (doLinesIntersect(
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

/// Checks whether two segments (p1-p2 and q1-q2) intersect.
bool doLinesIntersect(LatLng p1, LatLng p2, LatLng q1, LatLng q2) {
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

/// Arithmetic mean of vertices — gives a good "center" for convex, regular shapes.
/// For irregular shapes use the true centroid (mass-based), but that's not needed here.
LatLng? getPolygonVertexCenter(List<LatLng> points) {
  if (points.length < 3) return null;

  double sumLat = 0;
  double sumLng = 0;

  for (final point in points) {
    sumLat += point.latitude;
    sumLng += point.longitude;
  }

  return LatLng(sumLat / points.length, sumLng / points.length);
}
