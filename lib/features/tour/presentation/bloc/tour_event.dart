part of 'tour_bloc.dart';

abstract class TourEvent extends Equatable {}

class SelectTourEvent extends TourEvent {
  final String? tourId;
  SelectTourEvent({required this.tourId});

  @override
  List<Object?> get props => [tourId];
}

class GetToursEvent extends TourEvent {
  final String userId;
  final int page;
  final bool isLoadMore;
  final TourStatus? tourStatus;

  GetToursEvent({
    required this.userId,
    this.page = 1,
    this.isLoadMore = false,
    this.tourStatus,
  });

  @override
  List<Object?> get props => [userId, page, isLoadMore, tourStatus];
}
