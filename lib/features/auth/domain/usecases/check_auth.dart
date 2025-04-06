import 'package:milestory_crm/core/response/response.dart';

import '../entities/user_entity.dart';
import '../repository/auth_repository.dart';

class CheckAuth {
  final AuthRepository repository;

  CheckAuth(this.repository);

  Future<DataState<User>> call() async {
    return await repository.checkAuth();
  }
}
