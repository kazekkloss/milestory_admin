import '../../../../core/core_export.dart';

abstract class UsersRepository {
  Future<DataState<List<User>>> getUsers();
}
