import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core_export.dart';
import '../../../auth/auth_export.dart';
import '../../users_export.dart';

class UserEditor extends StatefulWidget {
  const UserEditor({super.key});

  @override
  State<UserEditor> createState() => _UserEditorState();
}

class _UserEditorState extends State<UserEditor> {
  late String _selectedRole;
  late bool _verify;
  User? _currentUser;
  User? _adminUser;

  @override
  void initState() {
    super.initState();
    _verify = false;
    _adminUser = context.read<AuthBloc>().state.user;
  }

  bool _hasDataChanged(UsersState state) {
    if (_currentUser == null || state.selectedUser == null) return false;
    return _selectedRole != state.selectedUser!.role || _verify != state.selectedUser!.verify;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      buildWhen: (previous, current) {
        return previous.selectedUser != current.selectedUser ||
            previous.editUserLoading != current.editUserLoading ||
            previous.deleteUserLoading != current.deleteUserLoading ||
            previous.logoutUserLoading != current.logoutUserLoading;
      },
      builder: (context, state) {
        if (state.selectedUser == null || state.selectedUser!.id.isEmpty) {
          _currentUser = null;
          _verify = false;
          return Container(
            decoration: const BoxDecoration(border: Border(left: BorderSide(color: Color.fromARGB(255, 49, 49, 49), width: 1.0))),
            child: const Padding(padding: EdgeInsets.all(20.0), child: Center(child: Text("Nie wybrano użytkownika"))),
          );
        }

        if (_currentUser != state.selectedUser) {
          _currentUser = state.selectedUser;
          _selectedRole = state.selectedUser!.role;
          _verify = state.selectedUser!.verify;
        }

        final isDataChanged = _hasDataChanged(state);

        return Container(
          decoration: const BoxDecoration(border: Border(left: BorderSide(color: Color.fromARGB(255, 49, 49, 49), width: 1.0))),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(state.selectedUser!.name ?? "Brak imienia", style: Theme.of(context).textTheme.headlineSmall),
                      Text(state.selectedUser!.email, style: Theme.of(context).textTheme.titleLarge),
                      Text(getRoleDescription(state.selectedUser!.role), style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                      const SizedBox(height: 50),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Zmień typ użytkownika", style: Theme.of(context).textTheme.bodyMedium!),
                          DropdownMenu<String>(
                            initialSelection: state.selectedUser!.role,
                            onSelected: (value) {
                              setState(() {
                                _selectedRole = value!;
                              });
                            },
                            dropdownMenuEntries: const [
                              DropdownMenuEntry(value: "T", label: "Podróżnik"),
                              DropdownMenuEntry(value: "G", label: "Przewodnik"),
                              DropdownMenuEntry(value: "A", label: "Admin"),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Checkbox(
                            value: _verify,
                            onChanged: (value) {
                              setState(() {
                                _verify = value!;
                              });
                            },
                          ),
                          const Text("Zweryfikowany"),
                        ],
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    spacing: 20,
                    children: [
                      CustomElevatedButton(
                        onPressed:
                            isDataChanged && !state.editUserLoading
                                ? () => showConfirmationDialog(
                                  context: context,
                                  title: "Zapisz",
                                  content: "Czy na pewno chcesz zaktualizować użytkownika?",
                                  onPressed:
                                      () => context.read<UsersBloc>().add(
                                        UpdateUserEvent(user: _currentUser!.copyWith(role: _selectedRole, verify: _verify)),
                                      ),
                                )
                                : null,
                        text: "Zapisz",
                        isLoading: state.editUserLoading,
                      ),
                      CustomElevatedButton(
                        onPressed:
                            _adminUser!.id != _currentUser!.id && !state.deleteUserLoading
                                ? () => showConfirmationDialog(
                                  context: context,
                                  title: "Usuń",
                                  content: "Czy na pewno chcesz usunąć użytkownika?",
                                  onPressed: () => context.read<UsersBloc>().add(DeleteUserEvent(userId: _currentUser!.id)),
                                )
                                : null,
                        text: "Usuń",
                        isLoading: state.deleteUserLoading,
                      ),
                      CustomElevatedButton(
                        onPressed:
                            _adminUser!.id != _currentUser!.id && !state.logoutUserLoading
                                ? () => showConfirmationDialog(
                                  context: context,
                                  title: "Wyloguj",
                                  content: "Czy na pewno chcesz wylogować użytkownika?",
                                  onPressed: () => context.read<UsersBloc>().add(LogoutUserEvent(userId: _currentUser!.id)),
                                )
                                : null,
                        text: "Wyloguj",
                        isLoading: state.logoutUserLoading,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
