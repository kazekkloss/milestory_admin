part of 'guide_application_bloc.dart';

class GuideApplicationState extends Equatable {
  final List<GuideApplication> guideApplicationList;
  final GuideApplication? selectedApplication;
  final bool getApplicationsLoading;
  final bool deleteApplicationLoading;
  final int? stats;
  final AppError? error;

  const GuideApplicationState({
    required this.guideApplicationList,
    this.getApplicationsLoading = false,
    this.deleteApplicationLoading = false,
    this.error,
    this.stats = 0,
    this.selectedApplication = GuideApplication.empty,
  });

  GuideApplicationState copyWith({
    List<GuideApplication>? guideApplicationList,
    AppError? error,
    bool? getApplicationsLoading,
    bool? deleteApplicationLoading,
    int? stats,
    GuideApplication? selectedApplication,
  }) {
    return GuideApplicationState(
      guideApplicationList: guideApplicationList ?? this.guideApplicationList,
      selectedApplication: selectedApplication ?? this.selectedApplication,
      error: error,
      getApplicationsLoading: getApplicationsLoading ?? this.getApplicationsLoading,
      deleteApplicationLoading: deleteApplicationLoading ?? this.deleteApplicationLoading,
      stats: stats ?? this.stats,
    );
  }

  @override
  List<Object?> get props => [getApplicationsLoading, guideApplicationList, error, stats, selectedApplication, deleteApplicationLoading];
}
