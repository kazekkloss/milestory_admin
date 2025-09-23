part of 'creator_bloc.dart';

class CreatorState extends Equatable {
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final List<TourPoint> tourPoints;
  final Set<Polygon> polygons;
  final String? selectedAreaId;
  final TourPoint? selectedTourPoint;
  final int? addAreaToPointId;
  final bool savePointLoading;
  final bool deletePointLoading;
  final bool getTourPointsLoading;
  final AppError? error;

  const CreatorState({
    required this.markers,
    required this.polylines,
    required this.tourPoints,
    required this.polygons,
    required this.selectedAreaId,
    this.savePointLoading = false,
    this.deletePointLoading = false,
    this.getTourPointsLoading = false,
    this.selectedTourPoint,
    this.addAreaToPointId,
    this.error,
  });

  CreatorState copyWith({
    Set<Marker>? markers,
    Set<Polyline>? polylines,
    List<TourPoint>? tourPoints,
    Set<Polygon>? polygons,
    Object? selectedAreaId = _undefined,
    Object? addAreaToPointId = _undefined,
    Object? error,
    Object? selectedTourPoint = _undefined,
    bool? savePointLoading,
    bool? deletePointLoading,
    bool? getTourPointsLoading,
  }) {
    return CreatorState(
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
      tourPoints: tourPoints ?? this.tourPoints,
      polygons: polygons ?? this.polygons,
      selectedTourPoint: selectedTourPoint == _undefined ? this.selectedTourPoint : selectedTourPoint as TourPoint?,
      selectedAreaId: selectedAreaId == _undefined ? this.selectedAreaId : selectedAreaId as String?,
      addAreaToPointId: addAreaToPointId == _undefined ? this.addAreaToPointId : addAreaToPointId as int?,
      error: error == _undefined ? this.error : error as AppError?,
      savePointLoading: savePointLoading ?? this.savePointLoading,
      deletePointLoading: deletePointLoading ?? this.deletePointLoading,
      getTourPointsLoading: getTourPointsLoading ?? this.getTourPointsLoading,
    );
  }

  static const _undefined = Object();

  @override
  List<Object?> get props => [
        markers,
        polylines,
        error,
        tourPoints,
        polygons,
        selectedAreaId,
        addAreaToPointId,
        selectedTourPoint,
        savePointLoading,
        deletePointLoading,
        getTourPointsLoading
      ];
}
