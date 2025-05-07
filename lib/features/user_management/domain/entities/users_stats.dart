class UsersStats {
  final int totalUsers;
  final int adminsCount;
  final int travelersCount;
  final int guidesCount;

  const UsersStats({
    required this.totalUsers,
    required this.adminsCount,
    required this.travelersCount,
    required this.guidesCount,
  });

  UsersStats copyWith({
    int? totalUsers,
    int? adminsCount,
    int? travelersCount,
    int? guidesCount,
  }) {
    return UsersStats(
      totalUsers: totalUsers ?? this.totalUsers,
      adminsCount: adminsCount ?? this.adminsCount,
      travelersCount: travelersCount ?? this.travelersCount,
      guidesCount: guidesCount ?? this.guidesCount,
    );
  }

  static const empty = UsersStats(
    totalUsers: 0,
    adminsCount: 0,
    travelersCount: 0,
    guidesCount: 0,
  );
}