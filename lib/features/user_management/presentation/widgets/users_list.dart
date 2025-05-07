import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core_export.dart';
import '../../users_export.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => _UserListState();
}

class _UserListState extends State<UsersList> {
  int _currentPage = 1;
  String? _selectedRole;
  bool? _selectedVerify;

  @override
  void initState() {
    context.read<UsersBloc>().add(GetUsersEvent(page: _currentPage));
    super.initState();
  }

  void _applyFilters() {
    setState(() {
      _currentPage = 1;
    });
    context.read<UsersBloc>().add(GetUsersEvent(page: _currentPage, role: _selectedRole, verify: _selectedVerify, isLoadMore: false));
  }

  void _loadMore() {
    setState(() {
      _currentPage++;
    });
    context.read<UsersBloc>().add(GetUsersEvent(page: _currentPage, role: _selectedRole, verify: _selectedVerify, isLoadMore: true));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: AppContainer(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 20,
                      children: [
                        Row(
                          children: [
                            Text("Typ użytkowników: ", style: CustomTextTheme.textTheme.labelMedium!),
                            DropdownMenu(
                              initialSelection: null,
                              dropdownMenuEntries: <DropdownMenuEntry<String?>>[
                                DropdownMenuEntry(value: null, label: "wszyscy"),
                                DropdownMenuEntry(value: "A", label: "Admini"),
                                DropdownMenuEntry(value: "T", label: "Podróżnicy"),
                                DropdownMenuEntry(value: "G", label: "Przewodnicy"),
                              ],
                              onSelected: (value) {
                                setState(() {
                                  _selectedRole = value;
                                });
                                _applyFilters();
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Weryfikacja konta : ", style: CustomTextTheme.textTheme.labelMedium!),
                            DropdownMenu(
                              initialSelection: null,
                              dropdownMenuEntries: <DropdownMenuEntry<bool?>>[
                                DropdownMenuEntry(value: null, label: "wszyscy"),
                                DropdownMenuEntry(value: true, label: "zweryfikowani"),
                                DropdownMenuEntry(value: false, label: "niezweryfikowani"),
                              ],
                              onSelected: (value) {
                                setState(() {
                                  _selectedVerify = value;
                                });
                                _applyFilters();
                              },
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _selectedRole = null;
                              _selectedVerify = null;
                              _currentPage = 1;
                            });
                            context.read<UsersBloc>().add(GetUsersEvent(page: _currentPage, isLoadMore: false));
                          },
                          icon: const Icon(Icons.refresh, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child:
                        state.userList.isEmpty
                            ? const Center(child: Text("Brak użytkowników"))
                            : GridView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 0,
                                childAspectRatio: 4,
                              ),
                              itemCount: state.userList.length + 1,
                              itemBuilder: (context, index) {
                                if (index == state.userList.length) {
                                  return state.userList.length % 20 == 0
                                      ? Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Container(
                                          color: CustomColorScheme.customColorScheme.onPrimary,
                                          child: Center(
                                            child: SizedBox(
                                              height: 40,
                                              width: 150,
                                              child: CustomElevatedButton(
                                                onPressed: _loadMore,
                                                text: "Załaduj więcej",
                                                isLoading: state.getUsersLoading,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                      : const SizedBox.shrink();
                                }
                                final user = state.userList[index];
                                return UserTab(user: user, selected: user.id == state.selectedUser!.id);
                              },
                            ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class UserTab extends StatelessWidget {
  final User user;
  final bool selected;
  const UserTab({super.key, required this.user, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: () => context.read<UsersBloc>().add(SelectUserEvent(userId: user.id)),
        child: Container(
          decoration: BoxDecoration(
            color: selected ? Theme.of(context).primaryColor : const Color.fromARGB(255, 49, 49, 49),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name ?? "Brak imienia",
                      style: selected ? CustomTextTheme.textTheme.labelMedium!.copyWith(color: Colors.black) : CustomTextTheme.textTheme.labelMedium!,
                    ),
                    Text(
                      user.email,
                      style: selected ? CustomTextTheme.textTheme.labelSmall!.copyWith(color: Colors.black) : CustomTextTheme.textTheme.labelSmall!,
                    ),
                  ],
                ),
                Text(
                  getRoleDescription(user.role),
                  style: selected ? CustomTextTheme.textTheme.labelSmall!.copyWith(color: Colors.black) : CustomTextTheme.textTheme.labelSmall!,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
