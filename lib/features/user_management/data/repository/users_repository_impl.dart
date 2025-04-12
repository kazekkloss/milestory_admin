import 'package:injectable/injectable.dart';
import '../../../../core/core_export.dart';
import '../../users_export.dart';

@LazySingleton(as: UsersRepository)
class UsersRepositoryImpl implements UsersRepository {
  final UsersDataSource usersDataSource;

  UsersRepositoryImpl({required this.usersDataSource});

  @override
  Future<DataState<List<User>>> getUsers() async {
    final response = await usersDataSource.getUsers();
    if (response is DataSuccess) {
      List<User> userList = response.data!.map((user) => UserModel.toEntity(user)).toList();
      return DataSuccess(userList);
    } else {
      return response;
    }
  }
}
