import 'package:injectable/injectable.dart';

import '../../../../core/core_export.dart';
import '../../users_export.dart';

@lazySingleton
class GetUsers {
  final UsersRepository repository;

  GetUsers(this.repository);

  Future<DataState<UsersResponse>> call({
    int page = 1,
    String? role,
    bool? verify,
  }) async {
    return await repository.getUsers(page: page, role: role, verify: verify);
  }
}