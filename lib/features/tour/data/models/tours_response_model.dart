import '../../../../core/core_export.dart';
import '../../tour_export.dart';

class ToursResponseModel extends ToursResponse {
  ToursResponseModel({required List<TourModel> tours, required ToursStatsModel stats})
      : super(tours: tours.map((tour) => TourModel.toEntity(tour)).toList(), stats: ToursStatsModel.toEntity(stats));

  factory ToursResponseModel.fromJson(Map<String, dynamic> json) {
    final toursList = (json['tours'] as List).map((tour) => TourModel.fromJson(tour)).toList();
    final stats = ToursStatsModel.fromJson(json['stats']);
    return ToursResponseModel(tours: toursList, stats: stats);
  }

  static ToursResponse toEntity(ToursResponseModel responseModel) {
    return ToursResponse(tours: responseModel.tours, stats: responseModel.stats);
  }
}