import 'package:injectable/injectable.dart';
import 'package:milestory_admin/core/core_export.dart';
import '../models/guide_user_info_model.dart';
import '../models/users_response_model.dart';
import '../../domain/entities/guide_user_info.dart';
import '../../domain/entities/users_response.dart';

abstract class UsersDataSource {
  Future<DataState<UsersResponse>> getUsers({int page, int limit});
  Future<DataState<GuideUserInfo>> getGuideUser(String guideUserId);
  Future<DataState<void>> updateUser(String userId, {String? type, bool? verify});
  Future<DataState<void>> logoutUser(String userId);
  Future<DataState<void>> deleteUser(String userId);
}

@LazySingleton(as: UsersDataSource)
class UsersDataSourceImpl implements UsersDataSource {
  final ApiClient apiClient;
  UsersDataSourceImpl(this.apiClient);

  @override
  Future<DataState<UsersResponse>> getUsers({int page = 1, int limit = 20}) async {
    try {
      final response = await apiClient.request(
        url: ApiConstants.getUsers,
        method: RequestMethod.get,
        queryParameters: {'page': page.toString(), 'limit': limit.toString()},
      );
      if (response is DataSuccess) return DataSuccess(UsersResponseModel.fromJson(response.data));
      return DataFailed(response.uiEvent!);
    } catch (e) {
      return DataFailed(UiEvent(message: e.toString()));
    }
  }

  @override
  Future<DataState<GuideUserInfo>> getGuideUser(String guideUserId) async {
    try {
      final response = await apiClient.request(
        url: ApiConstants.getGuideUser,
        method: RequestMethod.get,
        queryParameters: {'guideUserId': guideUserId},
      );
      if (response is DataSuccess) return DataSuccess(GuideUserInfoModel.fromJson(response.data));
      return DataFailed(response.uiEvent!);
    } catch (e) {
      return DataFailed(UiEvent(message: e.toString()));
    }
  }

  @override
  Future<DataState<void>> updateUser(String userId, {String? type, bool? verify}) async {
    try {
      final body = <String, dynamic>{'_id': userId};
      if (type != null) body['type'] = type;
      if (verify != null) body['verify'] = verify;
      final response = await apiClient.request(
        url: ApiConstants.updateUser,
        method: RequestMethod.post,
        data: body,
      );
      if (response is DataSuccess) return const DataSuccess(null);
      return DataFailed(response.uiEvent!);
    } catch (e) {
      return DataFailed(UiEvent(message: e.toString()));
    }
  }

  @override
  Future<DataState<void>> logoutUser(String userId) async {
    try {
      final response = await apiClient.request(
        url: ApiConstants.logoutUser,
        method: RequestMethod.delete,
        data: {'userId': userId},
      );
      if (response is DataSuccess) return const DataSuccess(null);
      return DataFailed(response.uiEvent!);
    } catch (e) {
      return DataFailed(UiEvent(message: e.toString()));
    }
  }

  @override
  Future<DataState<void>> deleteUser(String userId) async {
    try {
      final response = await apiClient.request(
        url: ApiConstants.deleteUser,
        method: RequestMethod.delete,
        data: {'userId': userId},
      );
      if (response is DataSuccess) return const DataSuccess(null);
      return DataFailed(response.uiEvent!);
    } catch (e) {
      return DataFailed(UiEvent(message: e.toString()));
    }
  }
}
