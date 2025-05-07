import '../../users_export.dart';

class GuideApplicationResponseModel extends GuideApplicationResponse {
  const GuideApplicationResponseModel({
    required super.guideApplications,
    required super.stats,
    required super.page,
    required super.limit,
  });

  factory GuideApplicationResponseModel.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('guideApplications') || !json.containsKey('stats')) {
      throw FormatException('Invalid JSON format for GuideApplicationResponse');
    }
    final guideApplicationsList = (json['guideApplications'] as List)
        .map((guideApplication) =>
            GuideApplicationModel.fromJson(guideApplication))
        .toList();
    final stats = json['stats'] as int;
    final page = json['page'] as int? ?? 1;
    final limit = json['limit'] as int? ?? 20;

    return GuideApplicationResponseModel(
      guideApplications:
          guideApplicationsList.map(GuideApplicationModel.toEntity).toList(),
      stats: stats,
      page: page,
      limit: limit,
    );
  }

  static GuideApplicationResponse toEntity(GuideApplicationResponseModel model) {
    return GuideApplicationResponse(
      guideApplications: model.guideApplications,
      stats: model.stats,
      page: model.page,
      limit: model.limit,
    );
  }
}