import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../users_export.dart';

class SearchUserList extends StatelessWidget {
  const SearchUserList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        return Positioned(
          top: 150,
          left: 20,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              height: state.searchUserList.isEmpty ? 0 : (state.searchUserList.length * 50.0).clamp(0, 200),
              decoration: BoxDecoration(color: Color.fromARGB(255, 49, 49, 49), borderRadius: BorderRadius.circular(10)),
              child: ListView.builder(
                itemCount: state.searchUserList.length,
                itemBuilder: (context, index) {
                  final user = state.searchUserList[index];
                  return InkWell(
                    onTap: () => context.read<UsersBloc>().add(SelectUserEvent(userId: user.id)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text(user.name ?? "Brak imienia", style: const TextStyle(fontSize: 16)),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
