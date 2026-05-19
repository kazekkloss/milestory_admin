part of 'auth_bloc.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

class AuthState extends Equatable {
  final UiEvent? uiEvent;
  final AuthStatus status;
  final User user;
  final bool loading;
  final bool passwordRecoverySent;
  final bool deleteAccountLoading;

  const AuthState({
    required this.user,
    required this.status,
    this.uiEvent,
    this.loading = false,
    this.passwordRecoverySent = false,
    this.deleteAccountLoading = false,
  });

  const AuthState._({
    this.status = AuthStatus.unknown,
    this.user = User.empty,
    this.uiEvent,
    this.loading = false,
    this.passwordRecoverySent = false,
    this.deleteAccountLoading = false,
  });

  const AuthState.unknown() : this._();

  const AuthState.authenticated(User user)
      : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    UiEvent? uiEvent,
    bool? loading,
    bool? passwordRecoverySent,
    bool? deleteAccountLoading,
  }) {
    return AuthState(
      user: user ?? this.user,
      status: status ?? this.status,
      uiEvent: uiEvent,
      loading: loading ?? this.loading,
      passwordRecoverySent: passwordRecoverySent ?? this.passwordRecoverySent,
      deleteAccountLoading: deleteAccountLoading ?? this.deleteAccountLoading,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        uiEvent,
        loading,
        passwordRecoverySent,
        deleteAccountLoading,
      ];
}
