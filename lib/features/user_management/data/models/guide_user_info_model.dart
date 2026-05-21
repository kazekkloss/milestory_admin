import '../../domain/entities/guide_user_info.dart';

class GuideUserInfoModel extends GuideUserInfo {
  const GuideUserInfoModel({
    required super.id,
    required super.name,
    super.imageUrl,
    super.bio,
  });

  factory GuideUserInfoModel.fromJson(Map<String, dynamic> json) {
    return GuideUserInfoModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      bio: json['bio'] as String?,
    );
  }
}
