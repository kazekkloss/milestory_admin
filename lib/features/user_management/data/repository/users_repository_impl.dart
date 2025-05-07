import 'package:injectable/injectable.dart';
import '../../../../core/core_export.dart';
import '../../users_export.dart';

@LazySingleton(as: UsersRepository)
class UsersRepositoryImpl implements UsersRepository {
  final UsersDataSource usersDataSource;

  UsersRepositoryImpl({required this.usersDataSource});

  @override
  Future<DataState<UsersResponse>> getUsers({int page = 1, String? role, bool? verify}) async {
    final response = await usersDataSource.getUsers(page: page, role: role, verify: verify);
    if (response is DataSuccess) {
      final usersResponse = response.data!;
      return DataSuccess(usersResponse);
    } else {
      return response;
    }
  }

  @override
  Future<DataState> deleteUser({required String userId}) async {
    final response = await usersDataSource.deleteUser(userId: userId);
    return response;
  }

  @override
  Future<DataState> logoutUser({required String userId}) async {
    final response = await usersDataSource.logoutUser(userId: userId);
    return response;
  }

  @override
  Future<DataState> updateUser({required User user}) async {
    UserModel userModel = UserModel.toModel(user);
    final response = await usersDataSource.updateUser(user: userModel);
    return response;
  }

  @override
  Future<DataState<List<User>>> searchUser({required String name}) async {
    final response = await usersDataSource.searchUser(name: name);
    if (response is DataSuccess) {
      List<User> users = response.data!.map((user) => UserModel.toEntity(user)).toList();
      return DataSuccess(users);
    } else {
      return response;
    }
  }

  @override
  Future<DataState<GuideApplicationResponse>> getGuideApplications({int page = 1}) async {
    final response = await usersDataSource.getGuideApplications();
    if (response is DataSuccess) {
      GuideApplicationResponse guideApplicationResponse = GuideApplicationResponseModel.toEntity(response.data!);
      return DataSuccess(guideApplicationResponse);
    } else {
      return response;
    }
  }
}
