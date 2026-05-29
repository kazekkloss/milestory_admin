import 'package:injectable/injectable.dart';
import 'package:milestory_admin/core/core_export.dart';
import '../datasources/users_data_source.dart';
import '../../domain/entities/guide_user_info.dart';
import '../../domain/entities/users_response.dart';
import '../../domain/repository/users_repository.dart';

@LazySingleton(as: UsersRepository)
class UsersRepositoryImpl implements UsersRepository {
  final UsersDataSource _dataSource;
  UsersRepositoryImpl(this._dataSource);

  @override
  Future<DataState<UsersResponse>> getUsers({int page = 1, int limit = 20, String? query}) =>
      _dataSource.getUsers(page: page, limit: limit, query: query);

  @override
  Future<DataState<GuideUserInfo>> getGuideUser(String guideUserId) =>
      _dataSource.getGuideUser(guideUserId);

  @override
  Future<DataState<void>> updateUser(String userId, {String? type, bool? verify}) =>
      _dataSource.updateUser(userId, type: type, verify: verify);

  @override
  Future<DataState<void>> logoutUser(String userId) =>
      _dataSource.logoutUser(userId);

  @override
  Future<DataState<void>> deleteUser(String userId) =>
      _dataSource.deleteUser(userId);
}
