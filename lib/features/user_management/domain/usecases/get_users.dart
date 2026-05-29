import 'package:injectable/injectable.dart';
import 'package:milestory_admin/core/core_export.dart';
import '../entities/users_response.dart';
import '../repository/users_repository.dart';

@lazySingleton
class GetUsers {
  final UsersRepository _repository;
  GetUsers(this._repository);

  Future<DataState<UsersResponse>> call({int page = 1, int limit = 20, String? query}) =>
      _repository.getUsers(page: page, limit: limit, query: query);
}
