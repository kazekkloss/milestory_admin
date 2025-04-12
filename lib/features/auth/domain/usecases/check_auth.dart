import 'package:injectable/injectable.dart';

import '../../../../core/core_export.dart';
import '../repository/auth_repository.dart';

@lazySingleton
class CheckAuth {
  final AuthRepository repository;

  CheckAuth(this.repository);

  Future<DataState<User>> call() async {
    return await repository.checkAuth();
  }
}
