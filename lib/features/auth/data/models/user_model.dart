import '../../domain/entities/user_entity.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
    super.password,
    required super.verify,
    required super.type,
    super.guideUserId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      email: json['email'],
      password: json['password'],
      verify: json['verify'] ?? false,
      type: json['type'] ?? 'user',
      guideUserId: json['guideUserId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'password': password,
      'verify': verify,
      'type': type,
      'guideUserId': guideUserId,
    };
  }
}
