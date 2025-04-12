import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core_export.dart';
import '../../users_export.dart';

part 'users_event.dart';
part 'users_state.dart';

@injectable
class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final GetUsers _getUsers;
  UsersBloc({required GetUsers getUsers}) : _getUsers = getUsers, super(UsersState(userList: [])) {
    on<GetUsersEvent>(_getUsersToState);
    on<SelectUserEvent>(_selectUserToState);
  }

  void _getUsersToState(GetUsersEvent event, Emitter<UsersState> emit) async {
    try {
      if (state.error != null) {
        emit(state.copyWith(error: null));
      }

      final response = await _getUsers.call();

      if (response is DataSuccess) {
        emit(state.copyWith(userList: response.data));
      } else {
        emit(state.copyWith(error: AppError(message: response.error!.message)));
      }
    } catch (e) {
      emit(state.copyWith(error: AppError(message: e.toString())));
    }
  }

  void _selectUserToState(SelectUserEvent event, Emitter<UsersState> emit) async {
    try {
      if (state.error != null) {
        emit(state.copyWith(error: null));
      }
      if (state.selectedUser!.id == event.userId) {
        emit(state.copyWith(selectedUser: User.empty));
      } else {
        final selectedUser = state.userList.firstWhere((user) => user.id == event.userId, orElse: () => User.empty);
        emit(state.copyWith(selectedUser: selectedUser));
      }
    } catch (e) {
      emit(state.copyWith(error: AppError(message: e.toString())));
    }
  }
}
