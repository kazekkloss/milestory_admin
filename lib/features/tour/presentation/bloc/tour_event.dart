part of 'tour_bloc.dart';

abstract class TourEvent extends Equatable {}

class SelectTourEvent extends TourEvent {
  final String? tourId;
  SelectTourEvent({required this.tourId});

  @override
  List<Object?> get props => [tourId];
}

class GetToursEvent extends TourEvent {
  final int page;
  final bool isLoadMore;
  final TourStatus? tourStatus;

  GetToursEvent({
    this.page = 1,
    this.isLoadMore = false,
    this.tourStatus,
  });

  @override
  List<Object?> get props => [page, isLoadMore, tourStatus];
}
