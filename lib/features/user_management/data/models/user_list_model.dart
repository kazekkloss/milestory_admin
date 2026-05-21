import '../../domain/entities/user_list_entity.dart';

class UserListModel extends UserListItem {
  const UserListModel({
    required super.id,
    required super.email,
    required super.type,
    required super.verify,
    super.guideUserId,
    super.createdAt,
  });

  factory UserListModel.fromJson(Map<String, dynamic> json) {
    return UserListModel(
      id: json['_id'] as String,
      email: json['email'] as String,
      type: json['type'] as String? ?? 'user',
      verify: json['verify'] as bool? ?? false,
      guideUserId: json['guideUserId'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }
}
