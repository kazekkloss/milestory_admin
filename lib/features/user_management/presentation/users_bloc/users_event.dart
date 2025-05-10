part of 'users_bloc.dart';

abstract class UsersEvent extends Equatable {}

class GetUsersEvent extends UsersEvent {
  final int page;
  final String? role;
  final bool? verify;
  final bool isLoadMore;

  GetUsersEvent({this.page = 1, this.role, this.verify, this.isLoadMore = false});

  @override
  List<Object?> get props => [page, role, verify, isLoadMore];
}

class SelectUserEvent extends UsersEvent {
  final String userId;
  SelectUserEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class UpdateUserEvent extends UsersEvent {
  final User user;

  UpdateUserEvent({required this.user});

  @override
  List<Object?> get props => [user];
}

class LogoutUserEvent extends UsersEvent {
  final String userId;

  LogoutUserEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class DeleteUserEvent extends UsersEvent {
  final String userId;

  DeleteUserEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class SearchUserEvent extends UsersEvent {
  final String name;

  SearchUserEvent({required this.name});

  @override
  List<Object?> get props => [name];
}
