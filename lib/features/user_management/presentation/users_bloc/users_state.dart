part of 'users_bloc.dart';

class UsersState extends Equatable {
  final List<User> userList;
  final List<User> searchUserList;
  final User? selectedUser;
  final AppError? error;
  final UsersStats? stats;
  final bool editUserLoading;
  final bool getUsersLoading;
  final bool deleteUserLoading;
  final bool logoutUserLoading;
  final bool searchUserLoading;

  const UsersState({
    required this.userList,
    required this.searchUserList,
    this.error,
    this.selectedUser = User.empty,
    this.stats,
    this.editUserLoading = false,
    this.getUsersLoading = false,
    this.deleteUserLoading = false,
    this.logoutUserLoading = false,
    this.searchUserLoading = false,
  });

  UsersState copyWith({
    List<User>? userList,
    List<User>? searchUserList,
    AppError? error,
    User? selectedUser,
    UsersStats? stats,
    bool? getUsersLoading,
    bool? editUserLoading,
    bool? deleteUserLoading,
    bool? logoutUserLoading,
    bool? searchUserLoading,
  }) {
    return UsersState(
      searchUserList: searchUserList ?? this.searchUserList,
      userList: userList ?? this.userList,
      error: error,
      selectedUser: selectedUser ?? this.selectedUser,
      stats: stats ?? this.stats,
      getUsersLoading: getUsersLoading ?? this.getUsersLoading,
      editUserLoading: editUserLoading ?? this.editUserLoading,
      deleteUserLoading: deleteUserLoading ?? this.deleteUserLoading,
      logoutUserLoading: logoutUserLoading ?? this.logoutUserLoading,
      searchUserLoading: searchUserLoading ?? this.searchUserLoading,
    );
  }

  @override
  List<Object?> get props => [
    searchUserList,
    userList,
    selectedUser,
    error,
    stats,
    getUsersLoading,
    editUserLoading,
    deleteUserLoading,
    logoutUserLoading,
    searchUserLoading,
  ];
}
