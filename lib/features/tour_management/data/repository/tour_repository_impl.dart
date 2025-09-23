import 'package:injectable/injectable.dart';
import '../../../../../core/core_export.dart';
import '../../tour_managenent_export.dart';

@LazySingleton(as: TourRepository)
class TourRepositoryImpl implements TourRepository {
  final TourDataSource tourDataSource;

  TourRepositoryImpl({required this.tourDataSource});

  @override
  Future<DataState<ToursResponse>> getTours({int page = 1, required String userId, String? tourStatus}) async {
    final response = await tourDataSource.getTours(page: page, userId: userId, tourStatus: tourStatus);
    if (response is DataSuccess) {
      final toursResponse = response.data!;
      return DataSuccess(toursResponse);
    } else {
      return response;
    }
  }

  @override
  Future<DataState> deleteTour({required String tourId}) async {
    final response = await tourDataSource.deleteTour(tourId: tourId);
    return response;
  }

  @override
  Future<DataState> deleteImage({required String imageUrl}) async {
    final response = await tourDataSource.deleteImage(imageUrl: imageUrl);
    return response;
  }

  @override
  Future<DataState> publishTour({required String tourId}) async {
    final response = await tourDataSource.publishTour(tourId: tourId);
    return response;
  }
}
