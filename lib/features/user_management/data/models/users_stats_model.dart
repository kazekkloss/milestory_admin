import '../../users_export.dart';

class UsersStatsModel extends UsersStats {
  UsersStatsModel({
    required super.totalUsers,
    required super.adminsCount,
    required super.travelersCount,
    required super.guidesCount,
  });

  factory UsersStatsModel.fromJson(Map<String, dynamic> json) {
    return UsersStatsModel(
      totalUsers: json['totalUsers'] as int,
      adminsCount: json['adminsCount'] as int,
      travelersCount: json['travelersCount'] as int,
      guidesCount: json['guidesCount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalUsers': totalUsers,
      'adminsCount': adminsCount,
      'travelersCount': travelersCount,
      'guidesCount': guidesCount,
    };
  }

  static UsersStats toEntity(UsersStatsModel statsModel) {
    return UsersStats(
      totalUsers: statsModel.totalUsers,
      adminsCount: statsModel.adminsCount,
      travelersCount: statsModel.travelersCount,
      guidesCount: statsModel.guidesCount,
    );
  }
}
