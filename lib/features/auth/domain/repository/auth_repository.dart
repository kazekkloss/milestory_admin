import 'package:milestory_crm/core/response/response.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<DataState<User>> signUp({required String email, required String password});
  Future<DataState<User>> signIn({required String email, required String password});
  Future<DataState<User>> checkAuth();
  Future<DataState> logout();
}
