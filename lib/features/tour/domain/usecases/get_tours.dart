import 'package:injectable/injectable.dart';
import '../../../../core/core_export.dart';
import '../../tour_export.dart';

@lazySingleton
class GetTours {
  final TourRepository repository;

  GetTours(this.repository);

  Future<DataState<ToursResponse>> call({int page = 1, required String userId, TourStatus? tourStatus}) async {
    return await repository.getTours(
      page: page,
      userId: userId,
      tourStatus: tourStatus != null ? TourStatusData.mapStatusEnumToApiString(tourStatus) : null,
    );
  }
}
