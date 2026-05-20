part of 'creator_bloc.dart';

abstract class CreatorEvent extends Equatable {}

class MapTappedEvent extends CreatorEvent {
  final LatLng latLng;
  MapTappedEvent(this.latLng);

  @override
  List<Object?> get props => [latLng];
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

class RemoveAreaEvent extends CreatorEvent {
  final String areaId;
  RemoveAreaEvent({required this.areaId});

  @override
  List<Object?> get props => [areaId];
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
