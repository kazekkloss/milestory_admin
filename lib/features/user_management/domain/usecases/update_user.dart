import 'package:injectable/injectable.dart';

import '../../../../core/core_export.dart';
import '../../users_export.dart';

@lazySingleton
class UpdateUser {
  final UsersRepository repository;

  UpdateUser(this.repository);

  Future<DataState> call({required User user}) async {
    return await repository.updateUser(user: user);
  }
}
