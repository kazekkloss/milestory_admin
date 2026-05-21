part of 'users_bloc.dart';

class UsersState extends Equatable {
  final List<UserListItem> users;
  final UsersStats? stats;
  final bool loading;
  final bool actionLoading;
  final UserListItem? selectedUser;
  final GuideUserInfo? guideUser;
  final bool guideUserLoading;
  final UiEvent? uiEvent;

  const UsersState({
    required this.users,
    this.stats,
    this.loading = false,
    this.actionLoading = false,
    this.selectedUser,
    this.guideUser,
    this.guideUserLoading = false,
    this.uiEvent,
  });

  UsersState copyWith({
    List<UserListItem>? users,
    UsersStats? stats,
    bool? loading,
    bool? actionLoading,
    bool? guideUserLoading,
    Object? selectedUser = _undefined,
    Object? guideUser = _undefined,
    Object? uiEvent = _undefined,
  }) {
    return UsersState(
      users: users ?? this.users,
      stats: stats ?? this.stats,
      loading: loading ?? this.loading,
      actionLoading: actionLoading ?? this.actionLoading,
      guideUserLoading: guideUserLoading ?? this.guideUserLoading,
      selectedUser: selectedUser == _undefined ? this.selectedUser : selectedUser as UserListItem?,
      guideUser: guideUser == _undefined ? this.guideUser : guideUser as GuideUserInfo?,
      uiEvent: uiEvent == _undefined ? this.uiEvent : uiEvent as UiEvent?,
    );
  }

  static const _undefined = Object();

  @override
  List<Object?> get props => [users, stats, loading, actionLoading, selectedUser, guideUser, guideUserLoading, uiEvent];
}
