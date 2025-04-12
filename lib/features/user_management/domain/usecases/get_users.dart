import 'package:injectable/injectable.dart';

import '../../../../core/core_export.dart';
import '../../users_export.dart';

@lazySingleton
class GetUsers {
  final UsersRepository repository;

  GetUsers(this.repository);

  Future<DataState<List<User>>> call() async {
    return await repository.getUsers();
  }
}
