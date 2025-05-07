import 'package:injectable/injectable.dart';
import '../../../../core/core_export.dart';
import '../repository/users_repository.dart';

@lazySingleton
class SearchUser {
  final UsersRepository repository;

  SearchUser(this.repository);

  Future<DataState<List<User>>> call({required String name}) async {
    return await repository.searchUser(name: name);
  }
}
