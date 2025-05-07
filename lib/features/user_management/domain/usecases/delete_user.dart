import 'package:injectable/injectable.dart';

import '../../../../core/core_export.dart';
import '../../users_export.dart';

@lazySingleton
class DeleteUser {
  final UsersRepository repository;

  DeleteUser(this.repository);

  Future<DataState> call({required String userId}) async {
    return await repository.deleteUser(userId: userId);
  }
}
