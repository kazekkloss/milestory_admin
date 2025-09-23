import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Area extends Equatable {
  final String id;
  final double? direction;
  final List<LatLng> latLng;

  const Area({
    required this.id,
    this.direction,
    required this.latLng,
  });

  Area copyWith({
    String? id,
    double? direction,
    List<LatLng>? latLng,
  }) {
    return Area(
      id: id ?? this.id,
      direction: direction == _undefined ? this.direction : direction,
      latLng: latLng ?? this.latLng,
    );
  }

  static const _undefined = Object();

  @override
  List<Object?> get props => [id, direction, latLng];
}