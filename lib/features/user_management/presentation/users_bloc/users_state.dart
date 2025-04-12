part of 'users_bloc.dart';

class UsersState extends Equatable {
  final List<User> userList;
  final User? selectedUser;
  final AppError? error;

  const UsersState({
    required this.userList,
    this.error,
    this.selectedUser = User.empty,
  });

  UsersState copyWith({
    List<User>? userList,
    AppError? error,
    User? selectedUser,
  }) {
    return UsersState(
      userList: userList ?? this.userList,
      error: error,
      selectedUser: selectedUser ?? this.selectedUser,
    );
  }

  @override
  List<Object?> get props => [userList, selectedUser, error];
}