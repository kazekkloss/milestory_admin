import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:collection/collection.dart';

import '../../../../core/core_export.dart';
import '../../creator_export.dart';

part 'creator_event.dart';
part 'creator_state.dart';

@injectable
class CreatorBloc extends Bloc<CreatorEvent, CreatorState> {
  final GetTourPoints _getTourPoints;

  CreatorBloc({required GetTourPoints getTourPoints})
      : _getTourPoints = getTourPoints,
        super(const CreatorState(
          markers: {},
          polylines: {},
          tourPoints: [],
          polygons: {},
          selectedAreaId: null,
        )) {
    on<CreateAreaEvent>(_onCreateArea);
    on<SelectAreaEvent>(_onSelectArea);
    on<GetTourPointsEvent>(_onGetTourPoints);
    on<SelectTourPointEvent>(_onSelectTourPoint);
  }

  void _onCreateArea(CreateAreaEvent event, Emitter<CreatorState> emit) {
    try {
      if (state.error != null) {
        emit(state.copyWith(error: null));
      }

      final markerPositions = state.markers.map((m) => m.position).toList();
      final polygons = Set<Polygon>.from(state.polygons);
      final tourPoints = List<TourPoint>.from(state.tourPoints);

      // Znajdujemy najwyższy istniejący identyfikator `Area` we wszystkich `tourPoints`
      final allAreas = tourPoints.expand((point) => point.areas).toList();
      final maxAreaId = allAreas.isNotEmpty ? allAreas.map((area) => int.tryParse(area.id) ?? 0).reduce((a, b) => a > b ? a : b) : 0;
      final newAreaId = (maxAreaId + 1).toString(); // Generujemy nowy unikalny ID

      // Tworzymy nowy obiekt `Area` z unikalnym ID
      final area = Area(
        id: newAreaId,
        direction: null,
        latLng: markerPositions,
      );

      if (state.addAreaToPointId != null) {
        // Dodajemy `Area` do istniejącego `TourPoint`
        final tourPointIndex = tourPoints.indexWhere((point) => point.id == state.addAreaToPointId);
        if (tourPointIndex != -1) {
          final updatedAreas = List<Area>.from(tourPoints[tourPointIndex].areas)..add(area);
          final updatedTourPoint = tourPoints[tourPointIndex].copyWith(areas: updatedAreas);
          tourPoints[tourPointIndex] = updatedTourPoint;
        }
      } else {
        // Tworzymy nowy `TourPoint` z `Area`
        final newTourPoint = TourPoint(
          id: tourPoints.length,
          title: null,
          description: null,
          areas: [area],
        );
        tourPoints.add(newTourPoint);
      }

      // Tworzymy `Polygon` dla `Area` i dodajemy go do stanu
      final polygon = Polygon(
        polygonId: PolygonId(area.id),
        points: markerPositions,
        strokeWidth: 2,
        strokeColor: Colors.blue,
        fillColor: Colors.blue.withOpacity(0.3),
        onTap: () {
          add(SelectAreaEvent(areaId: area.id));
        },
      );
      polygons.add(polygon);

      emit(state.copyWith(
        tourPoints: tourPoints,
        polygons: polygons,
        markers: {},
        polylines: {},
        addAreaToPointId: null,
      ));

      add(SelectAreaEvent(areaId: area.id));
      print(state.addAreaToPointId);
    } catch (e) {
      emit(state.copyWith(error: AppError(message: e.toString())));
    }
  }


  void _onSelectArea(SelectAreaEvent event, Emitter<CreatorState> emit) {
    try {
      if (state.error != null) {
        emit(state.copyWith(error: null));
      }

      final selectedAreaId = event.areaId;

      // Jeśli kliknięto już zaznaczoną area – odznacz wszystko
      if (state.selectedAreaId == selectedAreaId) {
        // Odznacz area i tourpoint
        final updatedPolygons = state.polygons.map((polygon) {
          return polygon.copyWith(
            fillColorParam: Colors.blue.withOpacity(0.3),
            strokeColorParam: Colors.blue,
          );
        }).toSet();

        emit(state.copyWith(
          polygons: updatedPolygons,
          selectedAreaId: null,
        ));
        return;
      }

      // Znajdź powiązany tourPoint po areaId
      final selectedTourPoint = state.tourPoints.firstWhereOrNull(
        (point) => point.areas.any((area) => area.id == event.areaId),
      );

      // Aktualizujemy kolory wszystkich obszarów
      final updatedPolygons = state.polygons.map((polygon) {
        final isSelected = selectedAreaId != null && polygon.polygonId.value == selectedAreaId;
        return polygon.copyWith(
          fillColorParam: isSelected ? Colors.red.withOpacity(0.3) : Colors.blue.withOpacity(0.3),
          strokeColorParam: isSelected ? Colors.red : Colors.blue,
        );
      }).toSet();

      // Emitujemy stan z zaznaczonym lub odznaczonym obszarem
      emit(state.copyWith(polygons: updatedPolygons, selectedAreaId: selectedAreaId, selectedTourPoint: selectedTourPoint));
    } catch (e) {
      emit(state.copyWith(error: AppError(message: e.toString())));
    }
  }

  void _onGetTourPoints(GetTourPointsEvent event, Emitter<CreatorState> emit) async {
    try {
      if (state.error != null) {
        emit(state.copyWith(error: null));
      }

      final response = await _getTourPoints(tourId: event.tourId);
      if (response is DataSuccess) {
        final polygons = <Polygon>{};
        for (final tourPoint in response.data!) {
          for (final area in tourPoint.areas) {
            final polygon = Polygon(
              polygonId: PolygonId(area.id),
              points: area.latLng,
              strokeWidth: 2,
              strokeColor: Colors.blue,
              fillColor: Colors.blue.withValues(alpha: 0.3),
              onTap: () {
                add(SelectAreaEvent(areaId: area.id));
              },
            );
            polygons.add(polygon);
          }
        }

        emit(state.copyWith(tourPoints: response.data, polygons: polygons));
      } else {
        emit(state.copyWith(error: response.error));
      }
    } catch (e) {
      emit(state.copyWith(error: AppError(message: e.toString())));
    }
  }


  void _onSelectTourPoint(SelectTourPointEvent event, Emitter<CreatorState> emit) {
    try {
      if (state.error != null) {
        emit(state.copyWith(error: null));
      }

      if (state.selectedTourPoint?.id == event.tourPointId) {
        emit(state.copyWith(selectedTourPoint: null));
        add(SelectAreaEvent(areaId: state.selectedAreaId));
        return;
      }

      final tourPoint = state.tourPoints.firstWhereOrNull((tp) => tp.id == event.tourPointId);

      emit(state.copyWith(selectedTourPoint: tourPoint));
    } catch (e) {
      emit(state.copyWith(error: AppError(message: e.toString())));
    }
  }
}
