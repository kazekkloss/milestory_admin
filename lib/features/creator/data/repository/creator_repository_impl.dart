import 'package:injectable/injectable.dart';

import '../../../../core/response/response.dart';
import '../../creator_export.dart';

@LazySingleton(as: CreatorRepository)
class CreatorRepositoryImpl implements CreatorRepository {
  final CreatorDataSource creatorDataSource;

  CreatorRepositoryImpl({required this.creatorDataSource});

  @override
  Future<DataState<List<TourPoint>>> getTourPoints({required String tourId}) async {
    final response = await creatorDataSource.getTourPoints(tourId: tourId);
    if (response is DataSuccess) {
      List<TourPoint> tourPoints = response.data!.map((road) => TourPointModel.toEntity(road)).toList();
      return DataSuccess(tourPoints);
    } else {
      return response;
    }
  }
}
