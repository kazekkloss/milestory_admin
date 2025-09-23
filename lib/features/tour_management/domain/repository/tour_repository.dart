import '../../../../../core/core_export.dart';
import '../../tour_managenent_export.dart';

abstract class TourRepository {
  Future<DataState> deleteImage({required String imageUrl});
  Future<DataState<ToursResponse>> getTours({int page, required String userId, String? tourStatus});
  Future<DataState> deleteTour({required String tourId});
  Future<DataState> publishTour({required String tourId});
}
