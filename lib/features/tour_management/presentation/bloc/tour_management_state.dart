part of 'tour_management_bloc.dart';

class TourManagementState extends Equatable {
  final List<Tour> tours;
  final AppError? error;
  final Tour? selectedTour;
  final bool saveTourLoading;
  final bool deleteTourLoading;
  final bool getToursLoading;
  final bool publishLoading;
  final ToursStats? stats;

  const TourManagementState({
    this.saveTourLoading = false,
    this.deleteTourLoading = false,
    this.getToursLoading = false,
    this.publishLoading = false,
    required this.tours,
    this.stats,
    this.error,
    this.selectedTour = Tour.empty,
  });

  TourManagementState copyWith({
    bool? saveTourLoading,
    bool? deleteTourLoading,
    bool? publishLoading,
    List<Tour>? tours,
    ToursStats? stats,
    AppError? error,
    Tour? selectedTour,
    bool? getToursLoading,
  }) {
    return TourManagementState(
      saveTourLoading: saveTourLoading ?? this.saveTourLoading,
      deleteTourLoading: deleteTourLoading ?? this.deleteTourLoading,
      selectedTour: selectedTour ?? this.selectedTour,
      publishLoading: publishLoading ?? this.publishLoading,
      getToursLoading: getToursLoading ?? this.getToursLoading,
      stats: stats ?? this.stats,
      tours: tours ?? this.tours,
      error: error,
    );
  }

  @override
  List<Object?> get props => [error, tours, selectedTour, saveTourLoading, deleteTourLoading, stats, publishLoading, getToursLoading];
}
