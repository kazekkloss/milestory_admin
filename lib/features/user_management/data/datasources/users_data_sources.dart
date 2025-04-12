import 'package:injectable/injectable.dart';
import '../../../../core/core_export.dart';

abstract class UsersDataSource {
  Future<DataState<List<UserModel>>> getUsers();
}

@LazySingleton(as: UsersDataSource)
class UsersDataSourceImpl implements UsersDataSource {
  final ApiClient apiClient;
  final TokenManager tokenManager;

  UsersDataSourceImpl(this.apiClient, this.tokenManager);

  @override
  Future<DataState<List<UserModel>>> getUsers() async {
    try {
      final response = await apiClient.request(url: ApiConstants.getUsers, method: RequestMethod.get);
      if (response is DataSuccess) {
        List<UserModel> userList = (response.data as List).map((userModel) => UserModel.fromJson(userModel)).toList();
        return DataSuccess(userList);
      } else {
        return DataFailed(response.error!);
      }
    } catch (e) {
      return DataFailed(AppError(message: e.toString()));
    }
  }
}
