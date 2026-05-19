import 'package:injectable/injectable.dart';
import '../../../../core/core_export.dart';
import '../../tour_export.dart';

@LazySingleton(as: TourRepository)
class TourRepositoryImpl implements TourRepository {
  final TourDataSource tourDataSource;

  TourRepositoryImpl({required this.tourDataSource});

  @override
  Future<DataState<ToursResponse>> getTours(
      {int page = 1, required String userId, String? tourStatus}) async {
    final response = await tourDataSource.getTours(
        page: page, userId: userId, tourStatus: tourStatus);
    if (response is DataSuccess) {
      return DataSuccess(response.data!);
    }
    return DataFailed(response.uiEvent!);
  }
}
