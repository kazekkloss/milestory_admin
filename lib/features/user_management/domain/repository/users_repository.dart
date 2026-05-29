import 'package:milestory_admin/core/core_export.dart';
import '../entities/guide_user_info.dart';
import '../entities/users_response.dart';

abstract class UsersRepository {
  Future<DataState<UsersResponse>> getUsers({int page = 1, int limit = 20, String? query});
  Future<DataState<GuideUserInfo>> getGuideUser(String guideUserId);
  Future<DataState<void>> updateUser(String userId, {String? type, bool? verify});
  Future<DataState<void>> logoutUser(String userId);
  Future<DataState<void>> deleteUser(String userId);
}
