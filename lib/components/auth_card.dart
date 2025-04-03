// ignore_for_file: constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';

enum AuthMode { Singup, Login}

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Text('Card'),
    );
  }
}