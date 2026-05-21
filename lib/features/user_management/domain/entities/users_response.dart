import 'user_list_entity.dart';
import 'users_stats.dart';

class UsersResponse {
  final List<UserListItem> users;
  final UsersStats stats;

  const UsersResponse({required this.users, required this.stats});

  static const empty = UsersResponse(users: [], stats: UsersStats.empty);
}
