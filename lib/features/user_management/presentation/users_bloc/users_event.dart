part of 'users_bloc.dart';

abstract class UsersEvent extends Equatable {}

class GetUsersEvent extends UsersEvent {
  GetUsersEvent();

  @override
  List<Object?> get props => [];
}

class SelectUserEvent extends UsersEvent {
  final String userId;
  SelectUserEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}
