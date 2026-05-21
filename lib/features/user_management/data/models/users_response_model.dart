import '../../domain/entities/users_response.dart';
import 'user_list_model.dart';
import 'users_stats_model.dart';

class UsersResponseModel extends UsersResponse {
  const UsersResponseModel({required super.users, required super.stats});

  factory UsersResponseModel.fromJson(Map<String, dynamic> json) {
    final usersList = (json['users'] as List)
        .map((u) => UserListModel.fromJson(u as Map<String, dynamic>))
        .toList();
    final stats = UsersStatsModel.fromJson(
        json['stats'] as Map<String, dynamic>? ?? {});
    return UsersResponseModel(users: usersList, stats: stats);
  }
}
