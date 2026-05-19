import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core_export.dart';
import '../../auth_export.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn _signIn;
  final Logout _logout;
  final CheckAuth _checkAuth;
  final SendPasswordRecoveryLink _sendPasswordRecoveryLink;
  final DeleteUser _deleteUser;

  AuthBloc({
    required SignIn signIn,
    required Logout logout,
    required CheckAuth checkAuth,
    required SendPasswordRecoveryLink sendPasswordRecoveryLink,
    required DeleteUser deleteUser,
  })  : _signIn = signIn,
        _logout = logout,
        _checkAuth = checkAuth,
        _sendPasswordRecoveryLink = sendPasswordRecoveryLink,
        _deleteUser = deleteUser,
        super(const AuthState.unknown()) {
    on<SignInEvent>(_signInEventToState);
    on<CheckAuthEvent>(_checkAuthToState);
    on<LogoutEvent>(_logoutToState);
    on<UpdateStateUserEvent>((event, emit) {
      emit(state.copyWith(user: event.updatedUser));
    });
    on<SendPasswordRecoveryLinkEvent>(_sendPasswordRecoveryLinkToState);
    on<DeleteAccountEvent>(_deleteAccountToState);
  }

  void _signInEventToState(SignInEvent event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(uiEvent: null, loading: true));
      final response =
          await _signIn.call(email: event.email, password: event.password);

      if (response is DataSuccess) {
        if (response.data!.isAdmin) {
          emit(AuthState.authenticated(response.data!).copyWith(loading: false));
        } else {
          emit(state.copyWith(
            loading: false,
            uiEvent: const UiEvent(
              message: "Brak uprawnień. To konto nie ma dostępu do panelu.",
              isError: true,
            ),
          ));
        }
      } else {
        emit(state.copyWith(uiEvent: response.uiEvent, loading: false));
      }
    } catch (e) {
      emit(state.copyWith(
        loading: false,
        uiEvent: const UiEvent(message: "Błąd logowania. Spróbuj ponownie."),
      ));
    }
  }

  void _checkAuthToState(CheckAuthEvent event, Emitter<AuthState> emit) async {
    try {
      if (state.uiEvent != null) {
        emit(state.copyWith(uiEvent: null));
      }
      final response = await _checkAuth.call();
      if (response is DataSuccess) {
        if (response.data!.isAdmin) {
          emit(AuthState.authenticated(response.data!).copyWith(loading: false));
        } else {
          emit(const AuthState.unauthenticated());
        }
      } else if (response.uiEvent!.message == 'Token is missing') {
        emit(const AuthState.unauthenticated());
      } else {
        emit(state.copyWith(uiEvent: response.uiEvent));
      }
    } catch (e) {
      emit(state.copyWith(uiEvent: UiEvent(message: e.toString())));
    }
  }

  void _logoutToState(LogoutEvent event, Emitter<AuthState> emit) async {
    try {
      if (state.uiEvent != null) {
        emit(state.copyWith(uiEvent: null));
      }
      final response = await _logout.call(isLocal: event.isLocal);
      if (response is DataSuccess) {
        emit(const AuthState.unauthenticated());
      } else {
        emit(state.copyWith(uiEvent: response.uiEvent));
      }
    } catch (e) {
      emit(state.copyWith(uiEvent: UiEvent(message: e.toString())));
    }
  }

  void _sendPasswordRecoveryLinkToState(
      SendPasswordRecoveryLinkEvent event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(uiEvent: null, loading: true, passwordRecoverySent: false));
      final response = await _sendPasswordRecoveryLink.call(email: event.email);
      if (response is DataSuccess) {
        emit(state.copyWith(
          loading: false,
          passwordRecoverySent: true,
          uiEvent: UiEvent.success(
            message: 'Link wysłany na ${event.email}. Sprawdź skrzynkę.',
          ),
        ));
      } else {
        emit(state.copyWith(loading: false, uiEvent: response.uiEvent));
      }
    } catch (e) {
      emit(state.copyWith(
        loading: false,
        uiEvent: UiEvent(message: e.toString()),
      ));
    }
  }

  Future<void> _deleteAccountToState(
      DeleteAccountEvent event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(uiEvent: null, deleteAccountLoading: true));
      final response = await _deleteUser.call(userId: state.user.id);
      if (response is DataSuccess) {
        emit(const AuthState.unauthenticated().copyWith(
          uiEvent: const UiEvent(
            message: 'Konto zostało pomyślnie usunięte',
            isError: false,
          ),
        ));
      } else {
        emit(state.copyWith(
            deleteAccountLoading: false, uiEvent: response.uiEvent));
      }
    } catch (e) {
      emit(state.copyWith(
          deleteAccountLoading: false,
          uiEvent: UiEvent(message: e.toString())));
    }
  }

}
