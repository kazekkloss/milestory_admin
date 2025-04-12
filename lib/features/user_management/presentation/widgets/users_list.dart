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
  @override
  void initState() {
    context.read<UsersBloc>().add(GetUsersEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0), // Dopasuj do stylu AppContainer
            child: AppContainer(
              child: Column(
                children: [
                  // Przycisk odświeżania
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.read<UsersBloc>().add(GetUsersEvent());
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text("Odśwież listę"),
                    ),
                  ),
                  // Lista użytkowników
                  Expanded(
                    child: Container(
                      child:
                          state.userList.isEmpty
                              ? const Center(child: Text("Brak użytkowników"))
                              : ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: state.userList.length,
                                itemBuilder: (context, index) {
                                  final user = state.userList[index];
                                  return UserTab(user: user, selected: user.id == state.selectedUser!.id);
                                },
                              ),
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
          height: 50,
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
                    Text(user.name ?? "Brak imienia", style: CustomTextTheme.textTheme.labelMedium!),
                    Text(user.email, style: CustomTextTheme.textTheme.labelSmall!),
                  ],
                ),
                Text(user.role),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
