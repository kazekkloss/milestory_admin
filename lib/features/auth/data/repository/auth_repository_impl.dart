import 'package:injectable/injectable.dart';
import 'package:milestory_crm/core/response/response.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../datasources/auth_data_source.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource authDataSource;

  AuthRepositoryImpl({required this.authDataSource});

  @override
  Future<DataState<User>> signUp({required String email, required String password}) async {
    final response = await authDataSource.signUp(email: email, password: password);
    return response;
  }

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
  Future<DataState> logout() async {
    final response = await authDataSource.logout();
    return response;
  }
}
