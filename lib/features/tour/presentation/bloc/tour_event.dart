part of 'tour_bloc.dart';

abstract class TourEvent extends Equatable {}

class SelectTourEvent extends TourEvent {
  final String? tourId;
  SelectTourEvent({required this.tourId});

  @override
  List<Object?> get props => [tourId];
}

class ChangeStatusEvent extends TourEvent {
  final String tourId;
  final TourStatus targetStatus;
  final TourStatus? sourceStatus;
  final String? rejectionReason;

  ChangeStatusEvent({
    required this.tourId,
    required this.targetStatus,
    this.sourceStatus,
    this.rejectionReason,
  });

  @override
  List<Object?> get props => [tourId, targetStatus, sourceStatus, rejectionReason];
}

class GetToursEvent extends TourEvent {
  final int page;
  final bool isLoadMore;
  final TourStatus? tourStatus;
  final String? userId;
  final String? title;

  GetToursEvent({
    this.page = 1,
    this.isLoadMore = false,
    this.tourStatus,
    this.userId,
    this.title,
  });

  @override
  List<Object?> get props => [page, isLoadMore, tourStatus, userId, title];
}
