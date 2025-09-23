import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../creator_export.dart';

class AreaModel extends Area {
  const AreaModel({
    required super.id,
    super.direction,
    required super.latLng,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'direction': direction,
      'latLng': latLng.map((point) => {'latitude': point.latitude, 'longitude': point.longitude}).toList(),
    };
  }

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(
      id: json['id'],
      direction: json['direction'],
      latLng: (json['latLng'] as List).map((point) => LatLng(point['latitude'], point['longitude'])).toList(),
    );
  }

  static AreaModel toModel(Area area) {
    return AreaModel(
      id: area.id,
      direction: area.direction,
      latLng: area.latLng,
    );
  }

  static Area toEntity(AreaModel areaModel) {
    return Area(
      id: areaModel.id,
      latLng: areaModel.latLng,
      direction: areaModel.direction,
    );
  }
}
