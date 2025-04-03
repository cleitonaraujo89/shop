import 'package:flutter/material.dart';

Future<void> alert(
    {required BuildContext context,
    required String title,
    required String content}) async {
  await showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Center(child: Text(title)),
      content: Text(content),
      actions: [
        //como a função é await vai esperar o click do usuário para fechar o Dialog
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
    //then do showDialog
  );
}
