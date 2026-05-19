import 'package:injectable/injectable.dart';
import 'package:milestory_admin/core/response/response.dart';
import '../repository/auth_repository.dart';

@lazySingleton
class DeleteUser {
  final AuthRepository repository;

  DeleteUser(this.repository);

  Future<DataState> call({required String userId}) async {
    return await repository.deleteUser(userId: userId);
  }
}
