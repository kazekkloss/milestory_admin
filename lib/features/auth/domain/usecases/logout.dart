import 'package:injectable/injectable.dart';
import 'package:milestory_admin/core/response/response.dart';
import '../repository/auth_repository.dart';

@lazySingleton
class Logout {
  final AuthRepository repository;

  Logout(this.repository);

  Future<DataState> call({required bool isLocal}) async {
    return await repository.logout(isLocal: isLocal);
  }
}