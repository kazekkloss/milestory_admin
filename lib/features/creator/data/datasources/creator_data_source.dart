import 'package:injectable/injectable.dart';
import '../../../../core/core_export.dart';
import '../../creator_export.dart';

abstract class CreatorDataSource {
  Future<DataState<List<TourPointModel>>> getTourPoints(
      {required String tourId});
}

@LazySingleton(as: CreatorDataSource)
class CreatorDataSourceImpl implements CreatorDataSource {
  final ApiClient apiClient;

  CreatorDataSourceImpl(this.apiClient);

  @override
  Future<DataState<List<TourPointModel>>> getTourPoints(
      {required String tourId}) async {
    try {
      final response = await apiClient.request(
        url: '${ApiConstants.getTourPoints}?tourId=$tourId',
        method: RequestMethod.get,
      );

      if (response is DataSuccess) {
        List<TourPointModel> tourPoints = (response.data as List)
            .map((tourPoint) => TourPointModel.fromJson(tourPoint))
            .toList();
        return DataSuccess(tourPoints);
      } else {
        return DataFailed(response.uiEvent!);
      }
    } catch (e) {
      return DataFailed(UiEvent(message: 'Unexpected error: ${e.toString()}'));
    }
  }
}
