import 'package:injectable/injectable.dart';
import 'package:milestory_admin/core/response/response.dart';
import '../../auth_export.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource authDataSource;

  AuthRepositoryImpl({required this.authDataSource});

  @override
  Future<DataState<User>> signIn(
      {required String email, required String password}) async {
    return await authDataSource.signIn(email: email, password: password);
  }

  @override
  Future<DataState<User>> checkAuth() async {
    return await authDataSource.checkAuth();
  }

  @override
  Future<DataState> logout({required bool isLocal}) async {
    return await authDataSource.logout(isLocal: isLocal);
  }

  @override
  Future<DataState> sendPasswordRecoveryLink({required String email}) async {
    return await authDataSource.sendPasswordRecoveryLink(email: email);
  }

  @override
  Future<DataState> deleteUser({required String userId}) async {
    return await authDataSource.deleteUser(userId: userId);
  }
}
