import 'package:milestory_admin/core/response/response.dart';
import '../../auth_export.dart';

abstract class AuthRepository {
  Future<DataState<User>> signIn({required String email, required String password});
  Future<DataState<User>> checkAuth();
  Future<DataState> logout({required bool isLocal});
  Future<DataState> sendPasswordRecoveryLink({required String email});
  Future<DataState> deleteUser({required String userId});
}
