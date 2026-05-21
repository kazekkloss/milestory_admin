part of 'users_bloc.dart';

abstract class UsersEvent extends Equatable {}

class GetUsersEvent extends UsersEvent {
  final int page;
  final bool isLoadMore;
  GetUsersEvent({this.page = 1, this.isLoadMore = false});
  @override
  List<Object?> get props => [page, isLoadMore];
}

class SelectUserEvent extends UsersEvent {
  final UserListItem? user;
  SelectUserEvent(this.user);
  @override
  List<Object?> get props => [user];
}

class UpdateUserTypeEvent extends UsersEvent {
  final String userId;
  final String type;
  UpdateUserTypeEvent({required this.userId, required this.type});
  @override
  List<Object?> get props => [userId, type];
}

class VerifyUserEvent extends UsersEvent {
  final String userId;
  VerifyUserEvent({required this.userId});
  @override
  List<Object?> get props => [userId];
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
