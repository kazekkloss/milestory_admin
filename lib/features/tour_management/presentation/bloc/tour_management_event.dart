part of 'tour_management_bloc.dart';

abstract class TourManagementEvent extends Equatable {}

class SelectTourEvent extends TourManagementEvent {
  final String? tourId;
  SelectTourEvent({required this.tourId});

  @override
  List<Object?> get props => [tourId];
}

class GetToursEvent extends TourManagementEvent {
  final String userId;
  final int page;
  final bool isLoadMore;
  final TourStatus? tourStatus;

  GetToursEvent({required this.userId, this.page = 1, this.isLoadMore = false, this.tourStatus});

  @override
  List<Object?> get props => [userId, page, isLoadMore, tourStatus];
}

class DeleteTourEvent extends TourManagementEvent {
  final String tourId;
  DeleteTourEvent({required this.tourId});

  @override
  List<Object?> get props => [tourId];
}

class SetPublicTourEvent extends TourManagementEvent {
  final String tourId;
  SetPublicTourEvent({required this.tourId});

  @override
  List<Object?> get props => [tourId];
}
