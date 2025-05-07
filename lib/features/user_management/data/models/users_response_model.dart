import '../../../../core/core_export.dart';
import '../../users_export.dart';

class UsersResponseModel extends UsersResponse {
  UsersResponseModel({required List<UserModel> users, required UsersStatsModel stats})
    : super(users: users.map((user) => UserModel.toEntity(user)).toList(), stats: UsersStatsModel.toEntity(stats));

  factory UsersResponseModel.fromJson(Map<String, dynamic> json) {
    final usersList = (json['users'] as List).map((user) => UserModel.fromJson(user)).toList();
    final stats = UsersStatsModel.fromJson(json['stats']);
    return UsersResponseModel(users: usersList, stats: stats);
  }

  static UsersResponse toEntity(UsersResponseModel responseModel) {
    return UsersResponse(users: responseModel.users, stats: responseModel.stats);
  }
}
