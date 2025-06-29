import 'package:flutter/material.dart';

void customAlertPermission(
    BuildContext context
    ) {
  AlertDialog(
    title: const Text('Location Permission'),
    content: const Text(
      'Please grant location permission to use this app.',
    ),
    actions: [
      TextButton(
        child: const Text('OK'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}
