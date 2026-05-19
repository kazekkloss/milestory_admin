import 'package:injectable/injectable.dart';
import 'package:milestory_admin/core/response/response.dart';

import '../entities/user_entity.dart';
import '../repository/auth_repository.dart';

@lazySingleton
class CheckAuth {
  final AuthRepository repository;

  CheckAuth(this.repository);

  Future<DataState<User>> call() async {
    return await repository.checkAuth();
  }
}
