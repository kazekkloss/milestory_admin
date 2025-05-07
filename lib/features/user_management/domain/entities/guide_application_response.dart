import '../../users_export.dart';

class GuideApplicationResponse {
  final List<GuideApplication> guideApplications;
  final int stats;
  final int page;
  final int limit;

  const GuideApplicationResponse({
    required this.guideApplications,
    required this.stats,
    required this.page,
    required this.limit,
  });

  GuideApplicationResponse copyWith({
    List<GuideApplication>? guideApplications,
    int? stats,
    int? page,
    int? limit,
  }) {
    return GuideApplicationResponse(
      guideApplications: guideApplications ?? this.guideApplications,
      stats: stats ?? this.stats,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }

  static const empty = GuideApplicationResponse(
    guideApplications: [],
    stats: 0,
    page: 1,
    limit: 20,
  );
}