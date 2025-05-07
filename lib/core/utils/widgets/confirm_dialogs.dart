import 'package:flutter/material.dart';

void showConfirmationDialog({required BuildContext context, required String title, required String content, required void Function() onPressed}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        title: Text(title, textAlign: TextAlign.center),
        content: Text(content, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),
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
              onPressed();
            },
            child: const Text('Tak'),
          ),
        ],
      );
    },
  );
}
