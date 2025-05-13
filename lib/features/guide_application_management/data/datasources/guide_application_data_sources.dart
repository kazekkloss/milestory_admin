import 'package:injectable/injectable.dart';
import '../../../../core/core_export.dart';
import '../../guide_application_export.dart';

abstract class GuideApplicationDataSource {
  Future<DataState<GuideApplicationResponseModel>> getGuideApplications({int page});
  Future<DataState> deleteGuideApplication({required String guideApplicationId});
  Future<DataState> setGuideApplication({required String guideApplicationId});
}

@LazySingleton(as: GuideApplicationDataSource)
class UsersDataSourceImpl implements GuideApplicationDataSource {
  final ApiClient apiClient;
  final TokenManager tokenManager;

  UsersDataSourceImpl(this.apiClient, this.tokenManager);

  @override
  Future<DataState<GuideApplicationResponseModel>> getGuideApplications({int page = 1}) async {
    try {
      final queryParams = {'page': page.toString()};

      final response = await apiClient.request(url: ApiConstants.getGuideApplications, method: RequestMethod.get, queryParameters: queryParams);

      if (response is DataSuccess) {
        final guideApplicationResponse = GuideApplicationResponseModel.fromJson(response.data);
        return DataSuccess(guideApplicationResponse);
      } else {
        return DataFailed(response.error!);
      }
    } catch (e) {
      return DataFailed(AppError(message: e.toString()));
    }
  }

  @override
  Future<DataState> deleteGuideApplication({required String guideApplicationId}) async {
    try {
      final response = await apiClient.request(
        url: ApiConstants.deleteGuideApplication,
        method: RequestMethod.delete,
        data: {'guideApplicationId': guideApplicationId},
      );

      if (response is DataSuccess) {
        return DataSuccess();
      } else {
        return DataFailed(response.error!);
      }
    } catch (e) {
      return DataFailed(AppError(message: e.toString()));
    }
  }

  @override
  Future<DataState> setGuideApplication({required String guideApplicationId}) async {
    try {
      final response = await apiClient.request(
        url: ApiConstants.setGuide,
        method: RequestMethod.delete,
        data: {'guideApplicationId': guideApplicationId},
      );

      if (response is DataSuccess) {
        return DataSuccess();
      } else {
        return DataFailed(response.error!);
      }
    } catch (e) {
      return DataFailed(AppError(message: e.toString()));
    }
  }
}
