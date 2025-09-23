import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../creator_export.dart';

class MapWidget extends StatefulWidget {
  final String tourId;
  const MapWidget({super.key, required this.tourId});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  static const _initialPosition = LatLng(50.091442, 20.010831);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatorBloc, CreatorState>(
      builder: (context, state) {
        return Expanded(
          child: GoogleMap(
            initialCameraPosition: const CameraPosition(target: _initialPosition, zoom: 13),
            mapType: MapType.hybrid,
            markers: state.markers,
            polylines: state.polylines,
            polygons: state.polygons,
          ),
        );
      },
    );
  }
}
