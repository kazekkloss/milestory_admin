import '../../../../core/core_export.dart';

abstract class AuthRepository {
  Future<DataState<User>> signIn({required String email, required String password});
  Future<DataState<User>> checkAuth();
  Future<DataState> logout({required bool isLocal});
}
