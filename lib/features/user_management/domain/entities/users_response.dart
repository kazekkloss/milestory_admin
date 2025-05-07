import '../../../../core/core_export.dart';
import '../../users_export.dart';

class UsersResponse {
  final List<User> users;
  final UsersStats stats;

  const UsersResponse({
    required this.users,
    required this.stats,
  });

  UsersResponse copyWith({
    List<User>? users,
    UsersStats? stats,
  }) {
    return UsersResponse(
      users: users ?? this.users,
      stats: stats ?? this.stats,
    );
  }

  static const empty = UsersResponse(
    users: [],
    stats: UsersStats.empty,
  );
}