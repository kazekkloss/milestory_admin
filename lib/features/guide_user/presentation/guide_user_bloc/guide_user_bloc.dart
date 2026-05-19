import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core_export.dart';
import '../../guide_user_export.dart';

part 'guide_user_event.dart';
part 'guide_user_state.dart';

@injectable
class GuideUserBloc extends Bloc<GuideUserEvent, GuideUserState> {
  final UpdateGuideUser _updateGuideUser;
  final GetGuideUser _getGuideUser;
  final MarkOnboardingSeen _markOnboardingSeen;

  GuideUserBloc({
    required UpdateGuideUser updateGuideUser,
    required GetGuideUser getGuideUser,
    required MarkOnboardingSeen markOnboardingSeen,
  })  : _updateGuideUser = updateGuideUser,
        _getGuideUser = getGuideUser,
        _markOnboardingSeen = markOnboardingSeen,
        super(const GuideUserState(guideUser: GuideUser.empty)) {
    on<UpdateGuideUserEvent>(_onUpdateGuideUser);
    on<GetGuideUserEvent>(_onGetGuideUser);
    on<MarkOnboardingSeenEvent>(_onMarkOnboardingSeen);
  }

  Future<void> _onUpdateGuideUser(
      UpdateGuideUserEvent event, Emitter<GuideUserState> emit) async {
    emit(state.copyWith(uiEvent: null, loading: true));

    final response = await _updateGuideUser.call(
      guideUser: event.guideUser,
      deleteAvatarUrl: event.deleteAvatarUrl,
    );

    if (response is DataSuccess) {
      emit(state.copyWith(
        guideUser: response.data,
        loading: false,
        uiEvent: const UiEvent(message: 'Profil zapisany', isError: false),
      ));
    } else {
      emit(state.copyWith(uiEvent: response.uiEvent, loading: false));
    }
  }

  Future<void> _onGetGuideUser(
      GetGuideUserEvent event, Emitter<GuideUserState> emit) async {
    emit(state.copyWith(uiEvent: null));

    final response = await _getGuideUser.call(guideUserId: event.guideUserId);

    if (response is DataSuccess) {
      emit(state.copyWith(guideUser: response.data, loading: false));
    } else {
      emit(state.copyWith(uiEvent: response.uiEvent, loading: false));
    }
  }

  Future<void> _onMarkOnboardingSeen(
      MarkOnboardingSeenEvent event, Emitter<GuideUserState> emit) async {
    emit(state.copyWith(uiEvent: null, onboardingLoading: true));

    final response = await _markOnboardingSeen.call(
        guideUserId: state.guideUser.id);

    if (response is DataSuccess) {
      emit(state.copyWith(
        onboardingLoading: false,
        guideUser: state.guideUser.copyWith(hasSeenCreatorOnboarding: true),
      ));
    } else {
      emit(state.copyWith(
          onboardingLoading: false, uiEvent: response.uiEvent));
    }
  }
}
