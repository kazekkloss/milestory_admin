part of 'guide_user_bloc.dart';

abstract class GuideUserEvent extends Equatable {}

class UpdateGuideUserEvent extends GuideUserEvent {
  final GuideUser guideUser;
  final String? deleteAvatarUrl;
  UpdateGuideUserEvent({required this.guideUser, this.deleteAvatarUrl});

  @override
  List<Object?> get props => [guideUser, deleteAvatarUrl];
}

class GetGuideUserEvent extends GuideUserEvent {
  final String guideUserId;
  GetGuideUserEvent({required this.guideUserId});

  @override
  List<Object?> get props => [guideUserId];
}

class MarkOnboardingSeenEvent extends GuideUserEvent {
  @override
  List<Object?> get props => [];
}
