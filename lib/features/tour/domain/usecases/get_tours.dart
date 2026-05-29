import 'package:injectable/injectable.dart';
import '../../../../core/core_export.dart';
import '../../tour_export.dart';

@lazySingleton
class GetTours {
  final TourRepository repository;

  GetTours(this.repository);

  Future<DataState<ToursResponse>> call({int page = 1, int limit = 20, TourStatus? tourStatus, String? userId, String? title}) async {
    return await repository.getTours(
      page: page,
      limit: limit,
      tourStatus: tourStatus != null ? TourStatusData.mapStatusEnumToApiString(tourStatus) : null,
      userId: userId,
      title: title,
    );
  }
}
