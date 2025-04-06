import 'package:milestory_crm/core/response/response.dart';
import '../repository/auth_repository.dart';

class Logout {
  final AuthRepository repository;

  Logout(this.repository);

  Future<DataState> call() async {
    return await repository.logout();
  }
}
