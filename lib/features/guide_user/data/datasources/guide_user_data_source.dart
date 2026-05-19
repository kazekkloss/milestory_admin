import 'package:injectable/injectable.dart';

import '../../../../core/core_export.dart';
import '../../guide_user_export.dart';

abstract class GuideUserDataSource {
  Future<DataState<GuideUserModel>> getGuideUser({required String guideUserId});
  Future<DataState> updateGuideUser({required GuideUserModel guideUser});
  Future<DataState> markOnboardingSeen({required String guideUserId});
}

@LazySingleton(as: GuideUserDataSource)
class GuideUserDataSourceImpl implements GuideUserDataSource {
  final ApiClient apiClient;

  GuideUserDataSourceImpl(this.apiClient);

  @override
  Future<DataState<GuideUserModel>> getGuideUser(
      {required String guideUserId}) async {
    try {
      final response = await apiClient.request(
        url: ApiConstants.getGuideUser,
        method: RequestMethod.get,
        queryParameters: {'guideUserId': guideUserId},
      );

      if (response is DataSuccess) {
        final guideUserModel = GuideUserModel.fromJson(response.data);
        return DataSuccess(guideUserModel);
      } else {
        return DataFailed(response.uiEvent!);
      }
    } catch (e) {
      return DataFailed(UiEvent(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<DataState> updateGuideUser({required GuideUserModel guideUser}) async {
    try {
      final response = await apiClient.request(
        url: ApiConstants.updateGuideUser,
        method: RequestMethod.post,
        data: guideUser.toJson(),
      );

      if (response is DataSuccess) {
        return const DataSuccess();
      } else {
        return DataFailed(response.uiEvent!);
      }
    } catch (e) {
      return DataFailed(UiEvent(message: e.toString()));
    }
  }

  @override
  Future<DataState> markOnboardingSeen({required String guideUserId}) async {
    try {
      final response = await apiClient.request(
        url: ApiConstants.updateGuideUser,
        method: RequestMethod.post,
        data: {'_id': guideUserId, 'hasSeenCreatorOnboarding': true},
      );

      if (response is DataSuccess) {
        return const DataSuccess();
      } else {
        return DataFailed(response.uiEvent!);
      }
    } catch (e) {
      return DataFailed(UiEvent(message: e.toString()));
    }
  }
}
