part of 'guide_application_bloc.dart';

abstract class GuideApplicationEvent extends Equatable {}

class GetGuideApplicationsEvent extends GuideApplicationEvent {
  final int page;
  final bool isLoadMore;

  GetGuideApplicationsEvent({this.page = 1, this.isLoadMore = false});

  @override
  List<Object> get props => [page, isLoadMore];
}

class SelectApplicationEvent extends GuideApplicationEvent {
  final String guideApplicationId;
  SelectApplicationEvent({required this.guideApplicationId});

  @override
  List<Object?> get props => [guideApplicationId];
}

class DeleteApplicationEvent extends GuideApplicationEvent {
  final String guideApplicationId;
  DeleteApplicationEvent({required this.guideApplicationId});

  @override
  List<Object?> get props => [guideApplicationId];
}

class SetGuideEvent extends GuideApplicationEvent {
  final String guideApplicationId;
  SetGuideEvent({required this.guideApplicationId});

  @override
  List<Object?> get props => [guideApplicationId];
}
