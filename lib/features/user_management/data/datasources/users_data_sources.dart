import 'package:injectable/injectable.dart';
import '../../../../core/core_export.dart';
import '../../users_export.dart';

abstract class UsersDataSource {
  Future<DataState<UsersResponse>> getUsers({int page, String? role, bool? verify});
  Future<DataState> updateUser({required UserModel user});
  Future<DataState> deleteUser({required String userId});
  Future<DataState> logoutUser({required String userId});
  Future<DataState<List<UserModel>>> searchUser({required String name});
}

@LazySingleton(as: UsersDataSource)
class UsersDataSourceImpl implements UsersDataSource {
  final ApiClient apiClient;
  final TokenManager tokenManager;

  UsersDataSourceImpl(this.apiClient, this.tokenManager);

  @override
  Future<DataState<UsersResponse>> getUsers({int page = 1, String? role, bool? verify}) async {
    try {
      final queryParams = {'page': page.toString(), if (role != null) 'role': role, if (verify != null) 'verify': verify.toString()};

      final response = await apiClient.request(url: ApiConstants.getUsers, method: RequestMethod.get, queryParameters: queryParams);

      if (response is DataSuccess) {
        final usersResponseModel = UsersResponseModel.fromJson(response.data);
        return DataSuccess(usersResponseModel);
      } else {
        return DataFailed(response.error!);
      }
    } catch (e) {
      return DataFailed(AppError(message: e.toString()));
    }
  }

  @override
  Future<DataState> deleteUser({required String userId}) async {
    try {
      final response = await apiClient.request(url: ApiConstants.deleteUser, method: RequestMethod.delete, data: {'userId': userId});

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
  Future<DataState> logoutUser({required String userId}) async {
    try {
      final response = await apiClient.request(url: ApiConstants.logoutUser, method: RequestMethod.delete, data: {'userId': userId});
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
  Future<DataState> updateUser({required UserModel user}) async {
    try {
      final response = await apiClient.request(url: ApiConstants.updateUser, method: RequestMethod.post, data: user.toJson());

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
  Future<DataState<List<UserModel>>> searchUser({required String name}) async {
    try {
      final response = await apiClient.request(url: '${ApiConstants.getUserByNme}?name=$name', method: RequestMethod.get);
      if (response is DataSuccess) {
        List<UserModel> users = (response.data as List).map((user) => UserModel.fromJson(user)).toList();
        return DataSuccess(users);
      } else {
        return DataFailed(response.error!);
      }
    } catch (e) {
      return DataFailed(AppError(message: e.toString()));
    }
  }
}
