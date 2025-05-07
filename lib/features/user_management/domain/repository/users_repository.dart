import '../../../../core/core_export.dart';
import '../../users_export.dart';

abstract class UsersRepository {
  Future<DataState<UsersResponse>> getUsers({int page, String? role, bool? verify});
  Future<DataState> updateUser({required User user});
  Future<DataState> deleteUser({required String userId});
  Future<DataState> logoutUser({required String userId});
  Future<DataState<List<User>>> searchUser({required String name});
  Future<DataState<GuideApplicationResponse>> getGuideApplications({int page});
}
