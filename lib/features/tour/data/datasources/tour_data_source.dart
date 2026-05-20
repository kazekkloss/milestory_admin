import 'package:injectable/injectable.dart';
import '../../../../core/core_export.dart';
import '../../tour_export.dart';

abstract class TourDataSource {
  Future<DataState<ToursResponse>> getTours({int page, int limit, String? tourStatus});
}

@LazySingleton(as: TourDataSource)
class TourDataSourceImpl implements TourDataSource {
  final ApiClient apiClient;

  TourDataSourceImpl(this.apiClient);

  @override
  Future<DataState<ToursResponse>> getTours(
      {int page = 1, int limit = 20, String? tourStatus}) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page.toString(),
        'limit': limit.toString(),
      };
      if (tourStatus != null) {
        queryParams['tourStatus'] = tourStatus;
      }

      final response = await apiClient.request(
        url: ApiConstants.getAllTours,
        method: RequestMethod.get,
        queryParameters: queryParams,
      );

      if (response is DataSuccess) {
        return DataSuccess(ToursResponseModel.fromJson(response.data));
      } else {
        return DataFailed(response.uiEvent!);
      }
    } catch (e) {
      return DataFailed(UiEvent(message: 'Unexpected error: ${e.toString()}'));
    }
  }
}
