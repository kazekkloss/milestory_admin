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
          tourPoints: [],
          polygons: {},
          selectedAreaId: null,
        )) {
    on<MapTappedEvent>(_onMapTapped);
    on<SelectAreaEvent>(_onSelectArea);
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
  void _onMapTapped(MapTappedEvent event, Emitter<CreatorState> emit) {
    final areaId = getAreaIdIfPointInside(
      point: event.latLng,
      polygons: state.polygons,
    );
    if (areaId != null) add(SelectAreaEvent(areaId: areaId));
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
