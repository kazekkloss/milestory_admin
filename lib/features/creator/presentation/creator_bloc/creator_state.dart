part of 'creator_bloc.dart';

class CreatorState extends Equatable {
  final List<TourPoint> tourPoints;
  final Set<Polygon> polygons;
  final String? selectedAreaId;
  final TourPoint? selectedTourPoint;
  final bool getTourPointsLoading;
  final UiEvent? uiEvent;
  final LatLng? cameraMoveTarget;

  const CreatorState({
    required this.tourPoints,
    required this.polygons,
    required this.selectedAreaId,
    this.getTourPointsLoading = false,
    this.selectedTourPoint,
    this.uiEvent,
    this.cameraMoveTarget,
  });

  CreatorState copyWith({
    List<TourPoint>? tourPoints,
    Set<Polygon>? polygons,
    Object? selectedAreaId = _undefined,
    Object? uiEvent = _undefined,
    Object? selectedTourPoint = _undefined,
    bool? getTourPointsLoading,
    LatLng? cameraMoveTarget,
  }) {
    return CreatorState(
      tourPoints: tourPoints ?? this.tourPoints,
      polygons: polygons ?? this.polygons,
      selectedTourPoint: selectedTourPoint == _undefined
          ? this.selectedTourPoint
          : selectedTourPoint as TourPoint?,
      selectedAreaId: selectedAreaId == _undefined
          ? this.selectedAreaId
          : selectedAreaId as String?,
      uiEvent: uiEvent == _undefined ? this.uiEvent : uiEvent as UiEvent?,
      getTourPointsLoading: getTourPointsLoading ?? this.getTourPointsLoading,
      cameraMoveTarget: cameraMoveTarget ?? this.cameraMoveTarget,
    );
  }

  static const _undefined = Object();

  factory CreatorState.initial() => const CreatorState(
        tourPoints: [],
        polygons: {},
        selectedAreaId: null,
      );

  @override
  List<Object?> get props => [
        uiEvent,
        tourPoints,
        polygons,
        selectedAreaId,
        selectedTourPoint,
        getTourPointsLoading,
        cameraMoveTarget,
      ];
}
