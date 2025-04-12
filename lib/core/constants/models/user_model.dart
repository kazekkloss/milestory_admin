import '../entities/user_entity.dart';

class UserModel extends User {
  UserModel({required super.id, required super.email, super.password, super.name, required super.verify, required super.role});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      email: json['email'],
      password: json['password'],
      name: json['name'],
      verify: json['verify'],
      role: json['role'] ?? 'T',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'email': email, 'password': password, 'name': name, 'verify': verify, 'role': role};
  }

  static User toEntity(UserModel userModel) {
    return User(
      id: userModel.id,
      email: userModel.email,
      password: userModel.password,
      name: userModel.name,
      verify: userModel.verify,
      role: userModel.role,
    );
  }
}
