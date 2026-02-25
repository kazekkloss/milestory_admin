import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/core_export.dart';
import '../../tour_managenent_export.dart';
part 'tour_management_event.dart';
part 'tour_management_state.dart';

@injectable
class TourManagementBloc extends Bloc<TourManagementEvent, TourManagementState> {
  final GetTours _getTours;
  final DeleteTour _deleteTour;
  final SetPublicTour _setPublicTour;
  final SetPrivateTour _setPrivateTour;

  ToursStats? _cachedStats;
  static const int _maxToursInMemory = 100;

  TourManagementBloc({
    required GetTours getTours,
    required DeleteTour deleteTour,
    required SetPublicTour setPublicTour,
    required SetPrivateTour setPrivateTour,
  }) : _getTours = getTours,
       _deleteTour = deleteTour,
       _setPublicTour = setPublicTour,
       _setPrivateTour = setPrivateTour,
       super(const TourManagementState(tours: [])) {
    on<GetToursEvent>(_onGetTours);
    on<DeleteTourEvent>(_onDeleteTour);
    on<SelectTourEvent>(_onSelectTour);
    on<SetPublicTourEvent>(_onSetPublicTour);
    on<SetPrivateTourEvent>((_onSetPrivateTour));
  }

  void _onSelectTour(SelectTourEvent event, Emitter<TourManagementState> emit) async {
    try {
      emit(state.copyWith(error: null));

      if (state.selectedTour!.id == event.tourId || event.tourId == null) {
        emit(state.copyWith(selectedTour: Tour.empty));
      } else {
        final selectedTour = state.tours.firstWhere((user) => user.id == event.tourId, orElse: () => Tour.empty);
        emit(state.copyWith(selectedTour: selectedTour));
      }
    } catch (e) {
      emit(state.copyWith(error: AppError(message: e.toString())));
    }
  }

  Future<void> _onGetTours(GetToursEvent event, Emitter<TourManagementState> emit) async {
    try {
      emit(state.copyWith(error: null, getToursLoading: event.page != 1 ? false : true));

      final shouldFetchStats = _cachedStats == null || !event.isLoadMore;

      final response = await _getTours.call(userId: event.userId, page: event.page, tourStatus: event.tourStatus);

      if (response is DataSuccess) {
        final toursResponse = response.data!;
        final newTours = toursResponse.tours;
        final stats = toursResponse.stats;

        if (shouldFetchStats) {
          _cachedStats = stats;
        }

        if (event.isLoadMore) {
          final updatedList = [...state.tours, ...newTours];
          final limitedList = updatedList.length > _maxToursInMemory ? updatedList.sublist(updatedList.length - _maxToursInMemory) : updatedList;
          emit(state.copyWith(tours: limitedList, stats: _cachedStats, getToursLoading: false));
        } else {
          emit(state.copyWith(tours: newTours, stats: _cachedStats, getToursLoading: false));
        }
      } else {
        emit(state.copyWith(error: AppError(message: response.error!.message), getToursLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(error: AppError(message: e.toString()), getToursLoading: false));
    }
  }

  Future<void> _onDeleteTour(DeleteTourEvent event, Emitter<TourManagementState> emit) async {
    try {
      emit(state.copyWith(error: null, deleteTourLoading: true));

      final response = await _deleteTour.call(tourId: event.tourId);

      if (response is DataSuccess) {
        final updatedTours = state.tours.where((tour) => tour.id != event.tourId).toList();
        emit(state.copyWith(tours: updatedTours, deleteTourLoading: false, selectedTour: Tour.empty));
      } else {
        emit(state.copyWith(error: response.error, deleteTourLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(deleteTourLoading: false, error: AppError(message: e.toString())));
    }
  }

  Future<void> _onSetPublicTour(SetPublicTourEvent event, Emitter<TourManagementState> emit) async {
    try {
      emit(state.copyWith(error: null, publishLoading: true));

      final response = await _setPublicTour.call(tourId: event.tourId);

      if (response is DataSuccess) {
        add(GetToursEvent(userId: state.selectedTour!.authorId));
        emit(
          state.copyWith(
            selectedTour: state.selectedTour!.copyWith(status: TourStatus.public),
            publishLoading: false,
            error: const AppError(message: "Trasa została opublikowana"),
          ),
        );
      } else {
        emit(state.copyWith(error: response.error, publishLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(publishLoading: false, error: AppError(message: e.toString())));
    }
  }

  Future<void> _onSetPrivateTour(SetPrivateTourEvent event, Emitter<TourManagementState> emit) async {
    try {
      emit(state.copyWith(error: null, publishLoading: true));

      final response = await _setPrivateTour.call(tourId: event.tourId);

      if (response is DataSuccess) {
        add(GetToursEvent(userId: state.selectedTour!.authorId));
        emit(
          state.copyWith(
            selectedTour: state.selectedTour!.copyWith(status: TourStatus.private),
            publishLoading: false,
            error: const AppError(message: "Trasa została ustawiona jako prywatna"),
          ),
        );
      } else {
        emit(state.copyWith(error: response.error, publishLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(publishLoading: false, error: AppError(message: e.toString())));
    }
  }
}
