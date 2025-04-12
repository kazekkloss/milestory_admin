import 'package:injectable/injectable.dart';
import '../../../../core/core_export.dart';
import '../../domain/repository/auth_repository.dart';
import '../datasources/auth_data_source.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource authDataSource;

  AuthRepositoryImpl({required this.authDataSource});

  @override
  Future<DataState<User>> signIn({required String email, required String password}) async {
    final response = await authDataSource.signIn(email: email, password: password);
    return response;
  }

  @override
  Future<DataState<User>> checkAuth() async {
    final response = await authDataSource.checkAuth();
    return response;
  }

  @override
  Future<DataState> logout(bool isLocal) async {
    final response = await authDataSource.logout(isLocal);
    return response;
  }
}
