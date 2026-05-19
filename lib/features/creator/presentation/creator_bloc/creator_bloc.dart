import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

import '../../creator_export.dart';

part 'creator_event.dart';
part 'creator_state.dart';

@injectable
class CreatorBloc extends Bloc<CreatorEvent, CreatorState> {
  final GetTourPoints _getTourPoints;
  final MapBuilders _mapBuilders;

  Color _accentColor = const Color(0xFFB1CBF3);

  CreatorBloc({
    required GetTourPoints getTourPoints,
    required MapBuilders mapBuilders,
  })  : _getTourPoints = getTourPoints,
        _mapBuilders = mapBuilders,
        super(const CreatorState(
          markers: {},
          polylines: {},
          tourPoints: [],
          polygons: {},
          selectedAreaId: null,
        )) {
    on<MapTappedEvent>(_onMapTapped);
    on<CreateAreaEvent>(_onCreateArea);
    on<SelectAreaEvent>(_onSelectArea);
    on<AddAreaToPointEvent>(_onAddAreaToPoint);
    on<DirectionEvent>(_onAddDirection);
    on<BackStepEvent>(_onBackStep);
    on<RemoveAreaEvent>(_onRemoveArea);

    on<GetTourPointsEvent>(_onGetTourPoints);
    on<SelectTourPointEvent>(_onSelectTourPoint);
    on<SetAccentColorEvent>(_onSetAccentColor);
    on<ResetCreatorEvent>((event, emit) => emit(CreatorState.initial()));
  }

  void _onSetAccentColor(SetAccentColorEvent event, Emitter<CreatorState> emit) {
    if (_accentColor == event.color) return;
    _accentColor = event.color;

    if (state.polygons.isEmpty) return;

    final updated = _mapBuilders.updateSelection(
      polygons: state.polygons,
      selectedId: state.selectedAreaId,
      accentColor: _accentColor,
    );
    emit(state.copyWith(polygons: updated));
  }

  // ========================= MAP TAP =========================
  void _onMapTapped(MapTappedEvent event, Emitter<CreatorState> emit) async {
    try {
      emit(state.copyWith(uiEvent: null));

      final currentMarkers = state.markers.toList();

      final areaId = getAreaIdIfPointInside(
        point: event.latLng,
        polygons: state.polygons,
      );

      if (currentMarkers.isEmpty && areaId != null) {
        add(SelectAreaEvent(areaId: areaId));
        return;
      }

      if (event.tourStatus == TourStatus.pendingReview) {
        emit(state.copyWith(
            uiEvent: const UiEvent(
                message: "Trasa jest weryfikowana, nie można jej edytować")));
        return;
      }

      if (areaId != null) {
        emit(state.copyWith(
            uiEvent: const UiEvent(
                message: "Nie można zaczynać wewnątrz istniejącego obszaru")));
        return;
      }

      if (!canAddSegment(
        newPoint: event.latLng,
        markers: currentMarkers,
        polygons: state.polygons,
      )) {
        emit(state.copyWith(
            uiEvent: const UiEvent(
                message: "Linia nie może przecinać istniejącego obszaru")));
        return;
      }

      if (doesSegmentIntersectCurrentDrawing(
        newPoint: event.latLng,
        markers: currentMarkers,
      )) {
        emit(state.copyWith(
            uiEvent: const UiEvent(
                message: "Linia nie może przecinać samej siebie")));
        return;
      }

      final newMarker = await _mapBuilders.createMarker(
        index: currentMarkers.length,
        position: event.latLng,
        isFirst: currentMarkers.isEmpty,
        onTap: () {
          if (state.polylines.length > 1) add(CreateAreaEvent());
        },
      );

      final markers = {...state.markers, newMarker};
      final polylines = Set<Polyline>.from(state.polylines);

      if (markers.length > 1) {
        polylines.add(
          _mapBuilders.createPolyline(
            index: polylines.length,
            points: markers.map((m) => m.position).toList(),
          ),
        );
      }

      emit(state.copyWith(
          markers: markers,
          polylines: polylines,
          isDrawingMode: true,
          uiEvent: null));
    } catch (e) {
      emit(state.copyWith(uiEvent: UiEvent(message: e.toString())));
    }
  }

  // ========================= CREATE AREA =========================
  void _onCreateArea(CreateAreaEvent event, Emitter<CreatorState> emit) {
    try {
      final points = state.markers.map((m) => m.position).toList();

      if (points.length < 3) {
        emit(state.copyWith(
            uiEvent: const UiEvent(
                message: "Obszar musi mieć co najmniej 3 punkty")));
        return;
      }

      if (doesNewAreaOverlap(
          newPoints: points, existingPolygons: state.polygons)) {
        emit(state.copyWith(
            uiEvent: const UiEvent(
                message: "Obszar nie może nakładać się na inny obszar")));
        return;
      }

      final newArea = createArea(
        tourPoints: state.tourPoints,
        points: points,
      );

      final updatedTourPoints = addAreaToTourPoints(
        tourPoints: state.tourPoints,
        area: newArea,
        addToPointId: state.addAreaToPointId,
      );

      final newPolygon = _mapBuilders.createPolygon(
        area: newArea,
        onTap: () => add(SelectAreaEvent(areaId: newArea.id)),
        accentColor: _accentColor,
      );

      emit(state.copyWith(
        tourPoints: updatedTourPoints,
        polygons: {...state.polygons, newPolygon},
        markers: {},
        polylines: {},
        addAreaToPointId: null,
        isDrawingMode: false,
        uiEvent: null,
      ));

      add(SelectAreaEvent(areaId: newArea.id));
    } catch (e) {
      emit(state.copyWith(uiEvent: UiEvent(message: e.toString())));
    }
  }

  // ========================= SELECT AREA =========================
  void _onSelectArea(SelectAreaEvent event, Emitter<CreatorState> emit) {
    try {
      final selectedId = event.areaId;

      LatLng? cameraTarget;
      if (selectedId != null) {
        final polygon = state.polygons.firstWhereOrNull(
          (p) => p.polygonId.value == selectedId,
        );

        if (polygon != null) {
          cameraTarget = getPolygonVertexCenter(polygon.points);
        }
      }

      if (state.selectedAreaId == selectedId) {
        final updatedPolygons = _mapBuilders.updateSelection(
          polygons: state.polygons,
          selectedId: null,
          accentColor: _accentColor,
        );

        emit(state.copyWith(
          polygons: updatedPolygons,
          selectedAreaId: null,
          cameraMoveTarget: null,
          selectedTourPoint: null,
          uiEvent: null,
        ));
        return;
      }

      final updatedPolygons = _mapBuilders.updateSelection(
        polygons: state.polygons,
        selectedId: selectedId,
        accentColor: _accentColor,
      );

      final selectedTourPoint = state.tourPoints.firstWhereOrNull(
        (tp) => tp.areas.any((a) => a.id == selectedId),
      );

      emit(state.copyWith(
        polygons: updatedPolygons,
        selectedAreaId: selectedId,
        selectedTourPoint: selectedTourPoint,
        cameraMoveTarget: cameraTarget,
        uiEvent: null,
      ));
    } catch (e) {
      emit(state.copyWith(uiEvent: UiEvent(message: e.toString())));
    }
  }

  // ========================= ADD AREA TO POINT =========================
  void _onAddAreaToPoint(AddAreaToPointEvent event, Emitter<CreatorState> emit) {
    emit(state.copyWith(
      addAreaToPointId: state.addAreaToPointId == event.tourPointId
          ? null
          : event.tourPointId,
      uiEvent: null,
    ));
  }

  // ========================= DIRECTION =========================
  void _onAddDirection(DirectionEvent event, Emitter<CreatorState> emit) {
    if (state.selectedAreaId == null) return;

    final updatedTourPoints = updateAreaDirection(
      tourPoints: state.tourPoints,
      areaId: state.selectedAreaId!,
      direction: event.direction,
    );

    emit(state.copyWith(tourPoints: updatedTourPoints, uiEvent: null));
  }

  // ========================= BACK STEP =========================
  void _onBackStep(BackStepEvent event, Emitter<CreatorState> emit) {
    final markers = List<Marker>.from(state.markers);
    final polylines = Set<Polyline>.from(state.polylines);

    if (markers.isEmpty) return;

    markers.removeLast();
    if (polylines.isNotEmpty) polylines.remove(polylines.last);

    emit(state.copyWith(
      markers: markers.toSet(),
      polylines: polylines,
      uiEvent: null,
    ));
  }

  // ========================= REMOVE AREA =========================
  void _onRemoveArea(RemoveAreaEvent event, Emitter<CreatorState> emit) {
    final updatedTourPoints = removeAreaFromTourPoints(
      tourPoints: state.tourPoints,
      areaId: event.areaId,
    );

    final updatedPolygons =
        state.polygons.where((p) => p.polygonId.value != event.areaId).toSet();

    emit(state.copyWith(
      tourPoints: updatedTourPoints,
      polygons: updatedPolygons,
      selectedAreaId:
          state.selectedAreaId == event.areaId ? null : state.selectedAreaId,
      uiEvent: null,
    ));
  }

  // ========================= GET TOUR POINTS =========================
  void _onGetTourPoints(GetTourPointsEvent event, Emitter<CreatorState> emit) async {
    emit(state.copyWith(uiEvent: null));

    final response = await _getTourPoints(tourId: event.tourId);
    if (response is DataSuccess) {
      final polygons = <Polygon>{};
      for (final tp in response.data!) {
        for (final area in tp.areas) {
          polygons.add(_mapBuilders.createPolygon(
            area: area,
            onTap: () => add(SelectAreaEvent(areaId: area.id)),
            accentColor: _accentColor,
          ));
        }
      }

      emit(state.copyWith(tourPoints: response.data, polygons: polygons));
    } else {
      emit(state.copyWith(uiEvent: response.uiEvent));
    }
  }

  // ========================= SELECT TOUR POINT =========================
  void _onSelectTourPoint(SelectTourPointEvent event, Emitter<CreatorState> emit) {
    emit(state.copyWith(uiEvent: null));

    try {
      if (state.selectedTourPoint?.id == event.tourPointId) {
        emit(state.copyWith(selectedTourPoint: null));
        add(SelectAreaEvent(areaId: null));
        return;
      }

      final tourPoint = state.tourPoints.firstWhereOrNull(
        (tp) => tp.id == event.tourPointId,
      );

      if (tourPoint == null) return;

      emit(state.copyWith(
        selectedTourPoint: tourPoint,
        uiEvent: null,
      ));

      if (tourPoint.areas.isNotEmpty) {
        final firstAreaId = tourPoint.areas.first.id;
        add(SelectAreaEvent(areaId: firstAreaId));
      } else {
        add(SelectAreaEvent(areaId: null));
      }
    } catch (e) {
      emit(state.copyWith(
          uiEvent: UiEvent(message: e.toString(), isError: true)));
    }
  }
}
