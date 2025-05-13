import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core_export.dart';
import '../../guide_application_export.dart';

part 'guide_application_event.dart';
part 'guide_application_state.dart';

@injectable
class GuideApplicationBloc extends Bloc<GuideApplicationEvent, GuideApplicationState> {
  final GetGuideApplications _getGuideApplications;
  final DeleteGuideApplication _deleteGuideApplication;
  final SetGuide _setGuide;
  int? _cachedStats;
  static const int _maxGuideApplicationsInMemory = 100;

  GuideApplicationBloc({
    required GetGuideApplications getGuideApplications,
    required DeleteGuideApplication deleteGuideApplication,
    required SetGuide setGuide,
  }) : _getGuideApplications = getGuideApplications,
       _deleteGuideApplication = deleteGuideApplication,
       _setGuide = setGuide,
       super(const GuideApplicationState(guideApplicationList: [])) {
    on<GetGuideApplicationsEvent>(_getGuideApplicationsToState);
    on<SelectApplicationEvent>(_selectApplicationToState);
    on<DeleteApplicationEvent>(_deleteApplicationToState);
    on<SetGuideEvent>(_setGuideToState);
  }

  void _selectApplicationToState(SelectApplicationEvent event, Emitter<GuideApplicationState> emit) async {
    try {
      emit(state.copyWith(error: null));

      if (state.selectedApplication!.id == event.guideApplicationId) {
        emit(state.copyWith(selectedApplication: GuideApplication.empty));
      } else {
        final selectedApplication = state.guideApplicationList.firstWhere(
          (guideApplication) => guideApplication.id == event.guideApplicationId,
          orElse: () => GuideApplication.empty,
        );
        emit(state.copyWith(selectedApplication: selectedApplication));
      }
    } catch (e) {
      emit(state.copyWith(error: AppError(message: e.toString())));
    }
  }

  void _getGuideApplicationsToState(GetGuideApplicationsEvent event, Emitter<GuideApplicationState> emit) async {
    try {
      emit(state.copyWith(error: null, getApplicationsLoading: true));

      final shouldFetchStats = _cachedStats == null || !event.isLoadMore;

      final response = await _getGuideApplications.call(page: event.page);

      if (response is DataSuccess) {
        final guideApplicationsResponse = response.data!;
        final newGuideApplications = guideApplicationsResponse.guideApplications;
        final stats = guideApplicationsResponse.stats;

        if (shouldFetchStats) {
          _cachedStats = stats;
        }

        if (event.isLoadMore) {
          final updatedList = [...state.guideApplicationList, ...newGuideApplications];
          final limitedList =
              updatedList.length > _maxGuideApplicationsInMemory
                  ? updatedList.sublist(updatedList.length - _maxGuideApplicationsInMemory)
                  : updatedList;
          emit(state.copyWith(guideApplicationList: limitedList, stats: _cachedStats, getApplicationsLoading: false));
        } else {
          emit(state.copyWith(guideApplicationList: newGuideApplications, stats: _cachedStats, getApplicationsLoading: false));
        }
      } else {
        emit(state.copyWith(error: AppError(message: response.error!.message), getApplicationsLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(error: AppError(message: e.toString()), getApplicationsLoading: false));
    }
  }

  void _deleteApplicationToState(DeleteApplicationEvent event, Emitter<GuideApplicationState> emit) async {
    try {
      emit(state.copyWith(error: null, deleteApplicationLoading: true));

      final response = await _deleteGuideApplication(guideApplicationId: event.guideApplicationId);
      if (response is DataSuccess) {
        final updatedGuideApplications =
            state.guideApplicationList.where((guideApplication) => guideApplication.id != event.guideApplicationId).toList();

        emit(
          state.copyWith(
            guideApplicationList: updatedGuideApplications,
            selectedApplication: state.selectedApplication?.id == event.guideApplicationId ? null : state.selectedApplication,
            deleteApplicationLoading: false,
          ),
        );
      } else {
        emit(state.copyWith(error: AppError(message: response.error!.message), deleteApplicationLoading: false));
      }

      emit(state.copyWith(deleteApplicationLoading: false));
    } catch (e) {
      emit(state.copyWith(error: AppError(message: e.toString())));
    }
  }

  void _setGuideToState(SetGuideEvent event, Emitter<GuideApplicationState> emit) async {
    try {
      emit(state.copyWith(error: null, setGuideLoading: true));

      final response = await _setGuide(guideApplicationId: event.guideApplicationId);
      if (response is DataSuccess) {
        final updatedGuideApplications =
            state.guideApplicationList.where((guideApplication) => guideApplication.id != event.guideApplicationId).toList();

        emit(state.copyWith(guideApplicationList: updatedGuideApplications, selectedApplication: null, setGuideLoading: false));
      } else {
        emit(state.copyWith(error: AppError(message: response.error!.message), setGuideLoading: false));
      }

      emit(state.copyWith(setGuideLoading: false));
    } catch (e) {
      emit(state.copyWith(error: AppError(message: e.toString())));
    }
  }
}
