import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core_export.dart';
import '../../auth_export.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthState.unknown()) {
    on<SignUpEvent>(_signUpEventToState);
    on<SignInEvent>(_signInEventToState);
    on<CheckAuthEvent>(_checkAuthToState);
    on<LogoutEvent>(_logoutToState);
  }

  void _signUpEventToState(SignUpEvent event, Emitter<AuthState> emit) async {
    try {
      if (state.error != null) {
        emit(state.copyWith(error: null));
      }
      final response = await SignUp(_authRepository).call(email: event.email, password: event.password);
      if (response is DataSuccess) {
      } else {
        emit(state.copyWith(
            error: AppError(apiError: ApiError(code: -1, message: "Uytkownik został utworzony, potwierdź adres mailowy i zaloguj się na konto"))));
      }
    } catch (e) {
      emit(state.copyWith(error: AppError(apiError: ApiError(code: -1, message: e.toString()))));
    }
  }

  void _signInEventToState(SignInEvent event, Emitter<AuthState> emit) async {
    try {
      if (state.error != null) {
        emit(state.copyWith(error: null));
      }
      final response = await SignIn(_authRepository).call(email: event.email, password: event.password);
      if (response is DataSuccess) {
        if (response.data!.verify == true) {
          emit(AuthState.authenticated(response.data!));
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
      final response = await CheckAuth(_authRepository).call();
      if (response is DataSuccess) {
        if (response.data!.verify == true) {
          emit(AuthState.authenticated(response.data!));
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
      final response = await Logout(_authRepository).call();
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
