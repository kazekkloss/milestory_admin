part of 'guide_user_bloc.dart';

class GuideUserState extends Equatable {
  final UiEvent? uiEvent;
  final GuideUser guideUser;
  final bool loading;
  final bool onboardingLoading;

  const GuideUserState({
    required this.guideUser,
    this.uiEvent,
    this.loading = false,
    this.onboardingLoading = false,
  });

  GuideUserState copyWith({
    GuideUser? guideUser,
    UiEvent? uiEvent,
    bool? loading,
    bool? onboardingLoading,
  }) {
    return GuideUserState(
      guideUser: guideUser ?? this.guideUser,
      uiEvent: uiEvent,
      loading: loading ?? this.loading,
      onboardingLoading: onboardingLoading ?? this.onboardingLoading,
    );
  }

  @override
  List<Object?> get props => [uiEvent, loading, onboardingLoading, guideUser];
}
