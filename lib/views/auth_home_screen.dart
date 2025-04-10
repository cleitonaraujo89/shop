import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/views/auth_screen.dart';
import 'package:shop/views/products_overview_screen.dart';

import '../providers/auth.dart';

class AuthOrHomeScreen extends StatelessWidget {
  const AuthOrHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);

    //chama o get pra saber se há uma sessão expirada
    if (auth.expiredToken) {
      // Adia a execução da função até o fim da contrução da tela
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Sua sessão expirou, entre novamente!',
              style: TextStyle(fontSize: 18),
            ),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () =>
                  ScaffoldMessenger.of(context).removeCurrentSnackBar(),
            ),
            duration: const Duration(seconds: 600),
          ),
        );
        //reseta a expired para false
        auth.expired();
      });
    }

    return FutureBuilder(
        future: auth.tryAutoLogin(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (snapshot.error != null) {
            return const Center(child: Text('Ocorreu um erro =/'));
          } else {
            //chama o get pra saber se o usuario ta logado ou não
            return auth.isAuth ? ProductsOverviewScreen() : const AuthScreen();
          }
        });
    //return auth.isAuth ? ProductsOverviewScreen() : const AuthScreen();
  }
}
