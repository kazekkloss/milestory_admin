part of 'auth_bloc.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

class AuthState extends Equatable {
  final AppError? error;
  final AuthStatus status;
  final User user;
  final bool loading;
  final bool googleLoading;

  const AuthState({
    required this.user,
    required this.status,
    this.error,
    this.loading = false,
    this.googleLoading = false,
  });

  const AuthState._({
    this.status = AuthStatus.unknown,
    this.user = User.empty,
    this.error,
    this.loading = false,
    this.googleLoading = false,
  });

  const AuthState.unknown() : this._();

  const AuthState.authenticated(User user) : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated() : this._(status: AuthStatus.unauthenticated);

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    AppError? error,
    bool? loading,
    bool? googleLoading,
  }) {
    return AuthState(
      user: user ?? this.user,
      status: status ?? this.status,
      error: error,
      loading: loading ?? this.loading,
      googleLoading: googleLoading ?? this.googleLoading,
    );
  }

  @override
  List<Object?> get props => [status, user, error, loading, googleLoading];
}
