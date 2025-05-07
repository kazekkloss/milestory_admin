import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth/auth_export.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("Zalogowany jako admin ${state.user.name ?? 'Brak imienia'}", style: Theme.of(context).textTheme.titleLarge),
                ),
                Expanded(child: Center(child: Text("Statystyki itp"))),
              ],
            ),
          ),
        );
      },
    );
  }
}
