part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {}

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

class UpdateStateUserEvent extends AuthEvent {
  final User updatedUser;
  UpdateStateUserEvent(this.updatedUser);

  @override
  List<Object?> get props => [updatedUser];
}

class SendPasswordRecoveryLinkEvent extends AuthEvent {
  final String email;
  SendPasswordRecoveryLinkEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class DeleteAccountEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}
