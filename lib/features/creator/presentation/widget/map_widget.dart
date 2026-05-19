import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:milestory_admin/features/creator/creator_export.dart';

class MapWidget extends StatefulWidget {
  final String tourId;
  final TourStatus tourStatus;
  const MapWidget({super.key, required this.tourId, required this.tourStatus});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  static const _initialPosition = LatLng(50.091442, 20.010831);
  late CreatorBloc _creatorBloc;

  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _creatorBloc = context.read<CreatorBloc>();
  }

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.of(context).accent;
    context.read<CreatorBloc>().add(SetAccentColorEvent(accent));

    return BlocConsumer<CreatorBloc, CreatorState>(
      listenWhen: (previous, current) =>
          previous.cameraMoveTarget != current.cameraMoveTarget &&
          current.cameraMoveTarget != null,
      listener: (context, state) {
        if (_mapController != null && state.cameraMoveTarget != null) {
          _mapController!.animateCamera(
            CameraUpdate.newLatLng(state.cameraMoveTarget!),
          );
        }
      },
      buildWhen: (previous, current) =>
          previous.markers != current.markers ||
          previous.polylines != current.polylines ||
          previous.polygons != current.polygons,
      builder: (context, state) {
        return GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: _initialPosition,
            zoom: 13,
          ),
          mapType: MapType.hybrid,
          markers: state.markers,
          polylines: state.polylines,
          polygons: state.polygons,

          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          myLocationButtonEnabled: false,
          compassEnabled: false,
          rotateGesturesEnabled: false,
          tiltGesturesEnabled: false,

          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
          },
          onTap: (latLng) {
            _creatorBloc
                .add(MapTappedEvent(latLng, widget.tourId, widget.tourStatus));
          },
        );
      },
    );
  }
}
