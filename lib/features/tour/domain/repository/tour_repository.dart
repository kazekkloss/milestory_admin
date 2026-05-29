import '../../../../core/core_export.dart';
import '../../tour_export.dart';

abstract class TourRepository {
  Future<DataState<ToursResponse>> getTours({int page, int limit, String? tourStatus, String? userId, String? title});
  Future<DataState<void>> changeStatus(String tourId, TourStatus targetStatus, {String? rejectionReason, TourStatus? sourceStatus});
}
