import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core_export.dart';
import '../../users_export.dart';

class TopTab extends StatefulWidget {
  const TopTab({super.key});

  @override
  State<TopTab> createState() => _TopTabState();
}

class _TopTabState extends State<TopTab> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        return Container(
          height: 150,
          margin: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Panel zarządzania użytkownikami", style: Theme.of(context).textTheme.titleLarge),
                      SizedBox(height: 40),
                      AppTextFormField(
                        controller: _searchController,
                        descriptionText: "wpisz nazwę użytkownika",
                        hintText: "np. Kazimierz",
                        onChanged: (value) {
                          context.read<UsersBloc>().add(SearchUserEvent(name: value));
                        },
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.cancel_outlined, color: Color.fromARGB(160, 255, 255, 255)),
                          onPressed: () {
                            _searchController.clear();
                            context.read<UsersBloc>().add(SearchUserEvent(name: _searchController.text));
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: 200,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Wszyscy:"),
                        Text(state.stats?.totalUsers.toString() ?? "Ładowanie", style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Podróżnicy:"),
                        Text(state.stats?.travelersCount.toString() ?? "Ładowanie", style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Przewodnicy:"),
                        Text(state.stats?.guidesCount.toString() ?? "Ładowanie", style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
