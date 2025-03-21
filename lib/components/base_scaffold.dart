import 'package:flutter/material.dart';

class BaseScaffold extends StatelessWidget {
  const BaseScaffold(
      {super.key,
      required this.title,
      required this.body,
      this.action,
      this.drawer});

  final String title;
  final Widget body;
  final List<Widget>? action;
  final Widget? drawer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        actions: action,
      ),
      body: body,
      drawer: drawer,
    );
  }
}
