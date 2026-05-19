import '../../guide_user_export.dart';

class GuideUserModel extends GuideUser {
  GuideUserModel({
    required super.id,
    required super.userId,
    super.name,
    super.guideDescription,
    super.tours,
    required super.createdAt,
    required super.updatedAt,
    super.avatarUrl,
    super.hasSeenCreatorOnboarding,
  });

  factory GuideUserModel.fromJson(Map<String, dynamic> json) {
    return GuideUserModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      guideDescription: json['bio'] ?? '',
      tours: json['tours'] != null ? List<String>.from(json['tours']) : [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      avatarUrl: json['imageUrl'] as String?,
      hasSeenCreatorOnboarding:
          json['hasSeenCreatorOnboarding'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'bio': guideDescription,
      'imageUrl': avatarUrl,
    };
  }

  static GuideUserModel toModel(GuideUser guideUser) {
    return GuideUserModel(
      id: guideUser.id,
      userId: guideUser.userId,
      name: guideUser.name,
      guideDescription: guideUser.guideDescription,
      tours: guideUser.tours,
      createdAt: guideUser.createdAt,
      updatedAt: guideUser.updatedAt,
      avatarUrl: guideUser.avatarUrl,
    );
  }
}
