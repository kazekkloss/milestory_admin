import 'package:injectable/injectable.dart';
import 'package:milestory_admin/core/response/response.dart';
import '../entities/user_entity.dart';
import '../repository/auth_repository.dart';

@lazySingleton
class SignIn {
  final AuthRepository repository;

  SignIn(this.repository);

  Future<DataState<User>> call({required String email, required String password}) async {
    return await repository.signIn(email: email, password: password);
  }
}
