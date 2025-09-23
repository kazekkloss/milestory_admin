part of 'creator_bloc.dart';

abstract class CreatorEvent extends Equatable {}

class CreateAreaEvent extends CreatorEvent {
  CreateAreaEvent();

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

class GetTourPointsEvent extends CreatorEvent {
  final String tourId;
  GetTourPointsEvent({required this.tourId});

  @override
  List<Object?> get props => [tourId];
}
