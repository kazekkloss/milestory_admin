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
  final UpdateUser _updateUser;
  final DeleteUser _deleteUser;
  final LogoutUser _logoutUser;
  final SearchUser _searchUser;
  UsersStats? _cachedStats;
  static const int _maxUsersInMemory = 100;

  UsersBloc({
    required GetUsers getUsers,
    required UpdateUser updateUser,
    required DeleteUser deleteUser,
    required LogoutUser logoutUser,
    required SearchUser searchUser,
  }) : _getUsers = getUsers,
       _updateUser = updateUser,
       _logoutUser = logoutUser,
       _deleteUser = deleteUser,
       _searchUser = searchUser,
       super(const UsersState(userList: [], searchUserList: [])) {
    on<GetUsersEvent>(_getUsersToState);
    on<SelectUserEvent>(_selectUserToState);
    on<UpdateUserEvent>(_updateUserToState);
    on<DeleteUserEvent>(_deleteUserToState);
    on<LogoutUserEvent>(_logoutUserToState);
    on<SearchUserEvent>(_searchUserToState);
  }

  void _getUsersToState(GetUsersEvent event, Emitter<UsersState> emit) async {
    try {
      emit(state.copyWith(error: null, getUsersLoading: true));

      final shouldFetchStats = _cachedStats == null || !event.isLoadMore;

      final response = await _getUsers.call(page: event.page, role: event.role, verify: event.verify);

      if (response is DataSuccess) {
        final usersResponse = response.data!;
        final newUsers = usersResponse.users;
        final stats = usersResponse.stats;

        if (shouldFetchStats) {
          _cachedStats = stats;
        }

        if (event.isLoadMore) {
          final updatedList = [...state.userList, ...newUsers];
          final limitedList = updatedList.length > _maxUsersInMemory ? updatedList.sublist(updatedList.length - _maxUsersInMemory) : updatedList;
          emit(state.copyWith(userList: limitedList, stats: _cachedStats, getUsersLoading: false));
        } else {
          emit(state.copyWith(userList: newUsers, stats: _cachedStats, getUsersLoading: false));
        }
      } else {
        emit(state.copyWith(error: AppError(message: response.error!.message), getUsersLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(error: AppError(message: e.toString()), getUsersLoading: false));
    }
  }

  void _selectUserToState(SelectUserEvent event, Emitter<UsersState> emit) async {
    try {
      emit(state.copyWith(error: null));

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

  void _updateUserToState(UpdateUserEvent event, Emitter<UsersState> emit) async {
    try {
      emit(state.copyWith(error: null, editUserLoading: true));

      final response = await _updateUser(user: event.user);

      if (response is DataSuccess) {
        final updatedUserList =
            state.userList.map((user) {
              return user.id == event.user.id ? event.user : user;
            }).toList();

        emit(state.copyWith(userList: updatedUserList, selectedUser: event.user, editUserLoading: false));
      } else {
        emit(state.copyWith(error: AppError(message: response.error!.message), editUserLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(error: AppError(message: e.toString()), editUserLoading: false));
    }
  }

  void _deleteUserToState(DeleteUserEvent event, Emitter<UsersState> emit) async {
    try {
      emit(state.copyWith(error: null, deleteUserLoading: true));

      final response = await _deleteUser(userId: event.userId);
      if (response is DataSuccess) {
        final updatedUserList = state.userList.where((user) => user.id != event.userId).toList();

        emit(
          state.copyWith(
            userList: updatedUserList,
            selectedUser: state.selectedUser?.id == event.userId ? null : state.selectedUser,
            deleteUserLoading: false,
          ),
        );
      } else {
        emit(state.copyWith(error: AppError(message: response.error!.message), deleteUserLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(error: AppError(message: e.toString()), deleteUserLoading: false));
    }
  }

  void _logoutUserToState(LogoutUserEvent event, Emitter<UsersState> emit) async {
    try {
      emit(state.copyWith(error: null, logoutUserLoading: true));

      final response = await _logoutUser(userId: event.userId);
      print(response);

      if (response is DataSuccess) {
        emit(state.copyWith(logoutUserLoading: false));
      } else {
        emit(state.copyWith(error: AppError(message: response.error!.message), logoutUserLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(error: AppError(message: e.toString()), logoutUserLoading: false));
    }
  }

  void _searchUserToState(SearchUserEvent event, Emitter<UsersState> emit) async {
    try {
      if (state.error != null) {
        emit(state.copyWith(error: null));
      }

      if (event.name.isNotEmpty) {
        emit(state.copyWith(searchUserLoading: true));
        final response = await _searchUser.call(name: event.name);
        if (response is DataSuccess) {
          emit(state.copyWith(searchUserList: response.data, error: null, searchUserLoading: false));
        } else {
          emit(state.copyWith(error: response.error, searchUserLoading: false));
        }
      } else {
        emit(state.copyWith(searchUserList: [], error: null, searchUserLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(error: AppError(message: e.toString())));
    }
  }
}
