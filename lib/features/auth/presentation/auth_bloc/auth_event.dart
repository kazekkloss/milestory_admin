part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;

  SignUpEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  SignInEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class CheckAuthEvent extends AuthEvent {

  CheckAuthEvent();

  @override
  List<Object?> get props => [];
}

class LogoutEvent extends AuthEvent {
  final bool isLocal;
  LogoutEvent({required this.isLocal});

  @override
  List<Object?> get props => [isLocal];
}
