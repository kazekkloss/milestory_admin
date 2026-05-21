import '../../domain/entities/users_stats.dart';

class UsersStatsModel extends UsersStats {
  const UsersStatsModel({required super.total});

  factory UsersStatsModel.fromJson(Map<String, dynamic> json) {
    return UsersStatsModel(total: json['total'] as int? ?? 0);
  }
}
