import 'package:injectable/injectable.dart';
import '../../../../core/core_export.dart';
import '../../tour_export.dart';

@LazySingleton(as: TourRepository)
class TourRepositoryImpl implements TourRepository {
  final TourDataSource tourDataSource;
  TourRepositoryImpl({required this.tourDataSource});

  @override
  Future<DataState<ToursResponse>> getTours(
      {int page = 1, int limit = 20, String? tourStatus, String? userId, String? title}) async {
    final response = await tourDataSource.getTours(page: page, limit: limit, tourStatus: tourStatus, userId: userId, title: title);
    if (response is DataSuccess) return DataSuccess(response.data!);
    return DataFailed(response.uiEvent!);
  }

  @override
  Future<DataState<void>> changeStatus(String tourId, TourStatus targetStatus, {String? rejectionReason, TourStatus? sourceStatus}) =>
      tourDataSource.changeStatus(tourId, targetStatus, rejectionReason: rejectionReason, sourceStatus: sourceStatus);
}
