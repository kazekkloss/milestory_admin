import '../../../../core/core_export.dart';
import '../../tour_export.dart';

class ToursResponseModel extends ToursResponse {
  ToursResponseModel({required List<TourModel> tours, required ToursStatsModel stats})
      : super(tours: tours.map((tour) => TourModel.toEntity(tour)).toList(), stats: ToursStatsModel.toEntity(stats));

  factory ToursResponseModel.fromJson(Map<String, dynamic> json) {
    final toursList = (json['tours'] as List).map((tour) => TourModel.fromJson(tour)).toList();
    final statsJson = json['stats'];
    final stats = statsJson != null
        ? ToursStatsModel.fromJson(statsJson as Map<String, dynamic>)
        : ToursStatsModel(totalTours: toursList.length);
    return ToursResponseModel(tours: toursList, stats: stats);
  }

  factory ToursResponseModel.fromList(List<dynamic> list) {
    final toursList = list.map((tour) => TourModel.fromJson(tour as Map<String, dynamic>)).toList();
    return ToursResponseModel(tours: toursList, stats: ToursStatsModel(totalTours: toursList.length));
  }

  static ToursResponse toEntity(ToursResponseModel responseModel) {
    return ToursResponse(tours: responseModel.tours, stats: responseModel.stats);
  }
}