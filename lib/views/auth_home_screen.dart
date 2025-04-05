import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/views/auth_screen.dart';
import 'package:shop/views/products_overview_screen.dart';

import '../providers/auth.dart';

class AuthOrHomeScreen extends StatelessWidget {
  const AuthOrHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //pega o provider
    Auth auth = Provider.of(context);
    //chama o get pra saber se o usuario ta logado ou não
    return auth.isAuth ? ProductsOverviewScreen() : const AuthScreen();
  }
}