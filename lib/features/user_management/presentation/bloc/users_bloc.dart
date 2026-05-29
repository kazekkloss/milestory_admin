import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:milestory_admin/core/core_export.dart';
import '../../domain/entities/guide_user_info.dart';
import '../../domain/entities/user_list_entity.dart';
import '../../domain/entities/users_stats.dart';
import '../../domain/repository/users_repository.dart';
import '../../domain/usecases/get_users.dart';

part 'users_event.dart';
part 'users_state.dart';

@injectable
class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final GetUsers _getUsers;
  final UsersRepository _repository;
  static const int _maxUsersInMemory = 200;

  UsersBloc({required GetUsers getUsers, required UsersRepository repository})
      : _getUsers = getUsers,
        _repository = repository,
        super(const UsersState(users: [])) {
    on<GetUsersEvent>(_onGetUsers);
    on<SelectUserEvent>(_onSelectUser);
    on<UpdateUserTypeEvent>(_onUpdateType);
    on<VerifyUserEvent>(_onVerify);
    on<LogoutUserEvent>(_onLogout);
    on<DeleteUserEvent>(_onDelete);
  }

  Future<void> _onGetUsers(GetUsersEvent event, Emitter<UsersState> emit) async {
    try {
      emit(state.copyWith(uiEvent: null, loading: event.page == 1 && !event.isLoadMore));
      final response = await _getUsers(page: event.page, query: event.query);
      if (response is DataSuccess) {
        final newUsers = response.data!.users;
        final stats = response.data!.stats;
        if (event.isLoadMore) {
          final merged = [...state.users, ...newUsers];
          final limited = merged.length > _maxUsersInMemory
              ? merged.sublist(merged.length - _maxUsersInMemory)
              : merged;
          emit(state.copyWith(users: limited, stats: stats, loading: false));
        } else {
          emit(state.copyWith(users: newUsers, stats: stats, loading: false));
        }
      } else {
        emit(state.copyWith(uiEvent: response.uiEvent, loading: false));
      }
    } catch (e) {
      emit(state.copyWith(uiEvent: UiEvent(message: e.toString()), loading: false));
    }
  }

  Future<void> _onSelectUser(SelectUserEvent event, Emitter<UsersState> emit) async {
    final user = event.user;
    if (user == null || user.id == state.selectedUser?.id) {
      emit(state.copyWith(selectedUser: null, guideUser: null));
      return;
    }
    emit(state.copyWith(selectedUser: user, guideUser: null, guideUserLoading: true, uiEvent: null));

    if (user.guideUserId != null && user.guideUserId!.isNotEmpty) {
      final response = await _repository.getGuideUser(user.guideUserId!);
      if (response is DataSuccess) {
        emit(state.copyWith(guideUser: response.data, guideUserLoading: false));
      } else {
        emit(state.copyWith(guideUser: null, guideUserLoading: false));
      }
    } else {
      emit(state.copyWith(guideUserLoading: false));
    }
  }

  Future<void> _onUpdateType(UpdateUserTypeEvent event, Emitter<UsersState> emit) async {
    emit(state.copyWith(actionLoading: true, uiEvent: null));
    final response = await _repository.updateUser(event.userId, type: event.type);
    if (response is DataSuccess) {
      final updated = state.users.map((u) =>
        u.id == event.userId ? _updateUserField(u, type: event.type) : u).toList();
      final updatedSelected = state.selectedUser?.id == event.userId
          ? _updateUserField(state.selectedUser!, type: event.type)
          : state.selectedUser;
      emit(state.copyWith(users: updated, selectedUser: updatedSelected, actionLoading: false));
    } else {
      emit(state.copyWith(uiEvent: response.uiEvent, actionLoading: false));
    }
  }

  Future<void> _onVerify(VerifyUserEvent event, Emitter<UsersState> emit) async {
    emit(state.copyWith(actionLoading: true, uiEvent: null));
    final response = await _repository.updateUser(event.userId, verify: true);
    if (response is DataSuccess) {
      final updated = state.users.map((u) =>
        u.id == event.userId ? _updateUserField(u, verify: true) : u).toList();
      final updatedSelected = state.selectedUser?.id == event.userId
          ? _updateUserField(state.selectedUser!, verify: true)
          : state.selectedUser;
      emit(state.copyWith(users: updated, selectedUser: updatedSelected, actionLoading: false));
    } else {
      emit(state.copyWith(uiEvent: response.uiEvent, actionLoading: false));
    }
  }

  Future<void> _onLogout(LogoutUserEvent event, Emitter<UsersState> emit) async {
    emit(state.copyWith(actionLoading: true, uiEvent: null));
    final response = await _repository.logoutUser(event.userId);
    if (response is DataSuccess) {
      emit(state.copyWith(actionLoading: false, uiEvent: const UiEvent(message: 'Użytkownik został wylogowany', isError: false)));
    } else {
      emit(state.copyWith(uiEvent: response.uiEvent, actionLoading: false));
    }
  }

  Future<void> _onDelete(DeleteUserEvent event, Emitter<UsersState> emit) async {
    emit(state.copyWith(actionLoading: true, uiEvent: null));
    final response = await _repository.deleteUser(event.userId);
    if (response is DataSuccess) {
      final updated = state.users.where((u) => u.id != event.userId).toList();
      emit(state.copyWith(
        users: updated,
        selectedUser: null,
        guideUser: null,
        actionLoading: false,
        uiEvent: const UiEvent(message: 'Konto zostało usunięte', isError: false),
      ));
    } else {
      emit(state.copyWith(uiEvent: response.uiEvent, actionLoading: false));
    }
  }

  UserListItem _updateUserField(UserListItem u, {String? type, bool? verify}) {
    return UserListItem(
      id: u.id,
      email: u.email,
      type: type ?? u.type,
      verify: verify ?? u.verify,
      guideUserId: u.guideUserId,
      createdAt: u.createdAt,
    );
  }
}
