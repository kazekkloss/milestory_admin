import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core_export.dart';
import '../../auth_export.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn _signIn;
  final CheckAuth _checkAuth;
  final Logout _logout;
  AuthBloc({required SignIn signIn, required CheckAuth checkAuth, required Logout logout})
    : _signIn = signIn,
      _checkAuth = checkAuth,
      _logout = logout,
      super(const AuthState.unknown()) {
    on<SignInEvent>(_signInEventToState);
    on<CheckAuthEvent>(_checkAuthToState);
    on<LogoutEvent>(_logoutToState);
  }

  void _signInEventToState(SignInEvent event, Emitter<AuthState> emit) async {
    try {
      if (state.error != null) {
        emit(state.copyWith(error: null));
      }
      final response = await _signIn.call(email: event.email, password: event.password);
      if (response is DataSuccess) {
        if (response.data!.verify == true) {
          if (response.data!.role == "A") {
            emit(AuthState.authenticated(response.data!));
          } else {
            emit(state.copyWith(error: AppError(apiError: ApiError(code: -1, message: "Ne posiadasz uprawnień aby się zalogować"))));
          }
        } else {
          emit(state.copyWith(error: AppError(apiError: ApiError(code: -1, message: "Potwierdź konto przez otrzymaną wiadomość"))));
        }
      } else {
        print(state.error!);
        emit(state.copyWith(error: response.error));
      }
    } catch (e) {
      emit(state.copyWith(error: AppError(message: e.toString())));
    }
  }

  void _checkAuthToState(CheckAuthEvent event, Emitter<AuthState> emit) async {
    try {
      if (state.error != null) {
        emit(state.copyWith(error: null));
      }
      final response = await _checkAuth.call();
      if (response is DataSuccess) {
        if (response.data!.verify == true) {
          if (response.data!.role == "A") {
            emit(AuthState.authenticated(response.data!));
          } else {
            emit(state.copyWith(error: AppError(apiError: ApiError(code: -1, message: "Ne posiadasz uprawnień aby się zalogować"))));
          }
        } else {
          emit(state.copyWith(error: AppError(apiError: ApiError(code: -1, message: "Potwierdź konto przez otrzymaną wiadomość"))));
        }
      } else if (response.error!.message == 'Token is missing') {
        emit(const AuthState.unauthenticated());
      } else {
        emit(state.copyWith(error: response.error));
      }
    } catch (e) {
      emit(state.copyWith(error: AppError(message: e.toString())));
    }
  }

  void _logoutToState(LogoutEvent event, Emitter<AuthState> emit) async {
    try {
      if (state.error != null) {
        emit(state.copyWith(error: null));
      }
      final response = await _logout.call(isLocal: event.isLocal);
      if (response is DataSuccess) {
        emit(const AuthState.unauthenticated());
      } else {
        emit(state.copyWith(error: response.error));
      }
    } catch (e) {
      emit(state.copyWith(error: AppError(message: e.toString())));
    }
  }
}
