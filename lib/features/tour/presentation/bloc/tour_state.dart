part of 'tour_bloc.dart';

class TourState extends Equatable {
  final List<Tour> tours;
  final List<Tour> allTours;
  final UiEvent? uiEvent;
  final Tour? selectedTour;
  final bool getToursLoading;
  final ToursStats? stats;

  const TourState({
    this.getToursLoading = false,
    required this.tours,
    this.allTours = const [],
    this.stats,
    this.uiEvent,
    this.selectedTour = Tour.empty,
  });

  TourState copyWith({
    List<Tour>? tours,
    List<Tour>? allTours,
    ToursStats? stats,
    UiEvent? uiEvent,
    Tour? selectedTour,
    bool? getToursLoading,
  }) {
    return TourState(
      selectedTour: selectedTour ?? this.selectedTour,
      getToursLoading: getToursLoading ?? this.getToursLoading,
      stats: stats ?? this.stats,
      tours: tours ?? this.tours,
      allTours: allTours ?? this.allTours,
      uiEvent: uiEvent ?? this.uiEvent,
    );
  }

  static const _blockingStatuses = {
    TourStatus.draft,
    TourStatus.pendingReview,
    TourStatus.rejected,
  };

  Tour? get blockingTour => allTours
      .where((t) => _blockingStatuses.contains(t.status))
      .firstOrNull;

  bool get hasActiveSlot => blockingTour != null;

  @override
  List<Object?> get props => [uiEvent, tours, allTours, selectedTour, stats, getToursLoading];
}
