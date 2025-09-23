import '../../tour_managenent_export.dart';

class ToursStatsModel extends ToursStats {
  ToursStatsModel({
    required super.totalTours,
  });

  factory ToursStatsModel.fromJson(Map<String, dynamic> json) {
    return ToursStatsModel(
      totalTours: json['totalTours'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalTours': totalTours,
    };
  }

  static ToursStats toEntity(ToursStatsModel statsModel) {
    return ToursStats(
      totalTours: statsModel.totalTours,
    );
  }
}