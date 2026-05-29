import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/core_export.dart';
import '../../tour_export.dart';
part 'tour_event.dart';
part 'tour_state.dart';

@injectable
class TourBloc extends Bloc<TourEvent, TourState> {
  final GetTours _getTours;
  final ChangeStatus _changeStatus;

  ToursStats? _cachedStats;
  static const int _maxToursInMemory = 100;

  TourBloc({required GetTours getTours, required ChangeStatus changeStatus})
      : _getTours = getTours,
        _changeStatus = changeStatus,
        super(const TourState(tours: [])) {
    on<GetToursEvent>(_onGetTours);
    on<SelectTourEvent>(_onSelectTour);
    on<ChangeStatusEvent>(_onChangeStatus);
  }

  void _onSelectTour(SelectTourEvent event, Emitter<TourState> emit) {
    try {
      emit(state.copyWith(uiEvent: null));
      if (state.selectedTour?.id == event.tourId || event.tourId == null) {
        emit(state.copyWith(selectedTour: Tour.empty));
      } else {
        final selectedTour = state.tours.firstWhere(
            (t) => t.id == event.tourId, orElse: () => Tour.empty);
        emit(state.copyWith(selectedTour: selectedTour));
      }
    } catch (e) {
      emit(state.copyWith(uiEvent: UiEvent(message: e.toString())));
    }
  }

  Future<void> _onChangeStatus(ChangeStatusEvent event, Emitter<TourState> emit) async {
    try {
      emit(state.copyWith(uiEvent: null));
      final response = await _changeStatus(
        event.tourId,
        event.targetStatus,
        rejectionReason: event.rejectionReason,
        sourceStatus: event.sourceStatus,
      );
      if (response is DataSuccess) {
        final updatedTours = state.tours.map((t) => t.id == event.tourId
            ? t.copyWith(
                status: event.targetStatus,
                rejectionReason: event.rejectionReason,
              )
            : t).toList();
        final updatedSelected = state.selectedTour?.id == event.tourId
            ? state.selectedTour!.copyWith(
                status: event.targetStatus,
                rejectionReason: event.rejectionReason,
              )
            : state.selectedTour;
        emit(state.copyWith(
          tours: updatedTours,
          allTours: updatedTours,
          selectedTour: updatedSelected,
          uiEvent: const UiEvent(message: 'Status zmieniony', isError: false),
        ));
      } else {
        emit(state.copyWith(uiEvent: response.uiEvent));
      }
    } catch (e) {
      emit(state.copyWith(uiEvent: UiEvent(message: e.toString())));
    }
  }

  Future<void> _onGetTours(GetToursEvent event, Emitter<TourState> emit) async {
    try {
      emit(state.copyWith(uiEvent: null, getToursLoading: event.page != 1 ? false : true));
      final isUnfiltered = event.tourStatus == null;
      final shouldFetchStats = isUnfiltered && (_cachedStats == null || !event.isLoadMore);
      final response = await _getTours.call(page: event.page, tourStatus: event.tourStatus, userId: event.userId, title: event.title);
      if (response is DataSuccess) {
        final newTours = response.data!.tours;
        final stats = response.data!.stats;
        if (shouldFetchStats) _cachedStats = stats;
        if (event.isLoadMore) {
          final updatedList = [...state.tours, ...newTours];
          final limitedList = updatedList.length > _maxToursInMemory
              ? updatedList.sublist(updatedList.length - _maxToursInMemory)
              : updatedList;
          emit(state.copyWith(
            tours: limitedList,
            allTours: isUnfiltered ? limitedList : null,
            stats: isUnfiltered ? _cachedStats : null,
            getToursLoading: false,
          ));
        } else {
          emit(state.copyWith(
            tours: newTours,
            allTours: isUnfiltered ? newTours : null,
            stats: isUnfiltered ? _cachedStats : null,
            getToursLoading: false,
          ));
        }
      } else {
        emit(state.copyWith(uiEvent: response.uiEvent, getToursLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(uiEvent: UiEvent(message: e.toString()), getToursLoading: false));
    }
  }
}
