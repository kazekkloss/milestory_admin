import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../users_export.dart';

class UserEditor extends StatelessWidget {
  const UserEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      buildWhen: (previous, current) {
        return previous.selectedUser != current.selectedUser;
      },
      builder: (context, state) {
        return Container(
          decoration: const BoxDecoration(border: Border(left: BorderSide(color: Color.fromARGB(255, 49, 49, 49), width: 1.0))),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text("Email: ${state.selectedUser!.email}"), Text("Nazwa usera: ${state.selectedUser!.name}")]),
                ElevatedButton(onPressed: () {}, child: Text("Edytuj Usera")),
              ],
            ),
          ),
        );
      },
    );
  }
}
