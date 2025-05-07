import 'package:injectable/injectable.dart';

import '../../../../core/core_export.dart';
import '../../users_export.dart';

@lazySingleton
class LogoutUser {
  final UsersRepository repository;

  LogoutUser(this.repository);

  Future<DataState> call({required String userId}) async {
    return await repository.logoutUser(userId: userId);
  }
}
