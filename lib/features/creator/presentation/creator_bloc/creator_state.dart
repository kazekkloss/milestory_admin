part of 'creator_bloc.dart';

class CreatorState extends Equatable {
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final List<TourPoint> tourPoints;
  final Set<Polygon> polygons;
  final String? selectedAreaId;
  final TourPoint? selectedTourPoint;
  final int? addAreaToPointId;
  final bool getTourPointsLoading;
  final bool isDrawingMode;
  final UiEvent? uiEvent;
  final LatLng? cameraMoveTarget;

  const CreatorState({
    required this.markers,
    required this.polylines,
    required this.tourPoints,
    required this.polygons,
    required this.selectedAreaId,
    this.getTourPointsLoading = false,
    this.selectedTourPoint,
    this.addAreaToPointId,
    this.isDrawingMode = false,
    this.uiEvent,
    this.cameraMoveTarget,
  });

  CreatorState copyWith({
    Set<Marker>? markers,
    Set<Polyline>? polylines,
    List<TourPoint>? tourPoints,
    Set<Polygon>? polygons,
    Object? selectedAreaId = _undefined,
    Object? addAreaToPointId = _undefined,
    Object? uiEvent = _undefined,
    Object? selectedTourPoint = _undefined,
    bool? isDrawingMode,
    bool? getTourPointsLoading,
    LatLng? cameraMoveTarget,
  }) {
    return CreatorState(
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
      tourPoints: tourPoints ?? this.tourPoints,
      polygons: polygons ?? this.polygons,
      selectedTourPoint: selectedTourPoint == _undefined
          ? this.selectedTourPoint
          : selectedTourPoint as TourPoint?,
      selectedAreaId: selectedAreaId == _undefined
          ? this.selectedAreaId
          : selectedAreaId as String?,
      addAreaToPointId: addAreaToPointId == _undefined
          ? this.addAreaToPointId
          : addAreaToPointId as int?,
      uiEvent: uiEvent == _undefined ? this.uiEvent : uiEvent as UiEvent?,
      isDrawingMode: isDrawingMode ?? this.isDrawingMode,
      getTourPointsLoading: getTourPointsLoading ?? this.getTourPointsLoading,
      cameraMoveTarget: cameraMoveTarget ?? this.cameraMoveTarget,
    );
  }

  static const _undefined = Object();

  factory CreatorState.initial() => const CreatorState(
        markers: {},
        polylines: {},
        tourPoints: [],
        polygons: {},
        selectedAreaId: null,
      );

  @override
  List<Object?> get props => [
        markers,
        polylines,
        uiEvent,
        tourPoints,
        polygons,
        selectedAreaId,
        addAreaToPointId,
        selectedTourPoint,
        isDrawingMode,
        getTourPointsLoading,
        cameraMoveTarget,
      ];
}
