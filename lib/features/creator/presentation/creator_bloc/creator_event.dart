part of 'creator_bloc.dart';

abstract class CreatorEvent extends Equatable {}

class MapTappedEvent extends CreatorEvent {
  final String roadId;
  final LatLng latLng;
  final TourStatus tourStatus;
  MapTappedEvent(this.latLng, this.roadId, this.tourStatus);

  @override
  List<Object?> get props => [roadId, latLng, tourStatus];
}

class CreateAreaEvent extends CreatorEvent {
  CreateAreaEvent();

  @override
  List<Object?> get props => [];
}

class BackStepEvent extends CreatorEvent {
  @override
  List<Object?> get props => [];
}

class SelectAreaEvent extends CreatorEvent {
  final String? areaId;
  SelectAreaEvent({this.areaId});

  @override
  List<Object?> get props => [areaId];
}

class SelectTourPointEvent extends CreatorEvent {
  final int tourPointId;
  SelectTourPointEvent({required this.tourPointId});

  @override
  List<Object?> get props => [tourPointId];
}

class AddAreaToPointEvent extends CreatorEvent {
  final int tourPointId;
  AddAreaToPointEvent({required this.tourPointId});

  @override
  List<Object?> get props => [tourPointId];
}

class RemoveAreaEvent extends CreatorEvent {
  final String areaId;
  RemoveAreaEvent({required this.areaId});

  @override
  List<Object?> get props => [areaId];
}

class DirectionEvent extends CreatorEvent {
  final double? direction;
  DirectionEvent({required this.direction});

  @override
  List<Object?> get props => [direction];
}

class GetTourPointsEvent extends CreatorEvent {
  final String tourId;
  GetTourPointsEvent({required this.tourId});

  @override
  List<Object?> get props => [tourId];
}

class SetAccentColorEvent extends CreatorEvent {
  final Color color;
  SetAccentColorEvent(this.color);

  @override
  List<Object?> get props => [color];
}

class ResetCreatorEvent extends CreatorEvent {
  @override
  List<Object?> get props => [];
}
