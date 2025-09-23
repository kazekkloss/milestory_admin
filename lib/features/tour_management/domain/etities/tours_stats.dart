class ToursStats {
  final int totalTours;

  const ToursStats({
    required this.totalTours,
  });

  ToursStats copyWith({
    int? totalTours,
  }) {
    return ToursStats(
      totalTours: totalTours ?? this.totalTours,
    );
  }

  static const empty = ToursStats(
    totalTours: 0,
  );
}
