import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/auth/auth_export.dart';

void showLogoutConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        title: const Text('Wylogowanie', textAlign: TextAlign.center),
        content: Text('Czy na pewno chcesz się wylogować?', style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Nie'),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AuthBloc>().add(LogoutEvent(isLocal: false));
            },
            child: const Text('Tak'),
          ),
        ],
      );
    },
  );
}
