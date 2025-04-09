import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../utils/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            toolbarHeight: 85,
            title: const Text('Bem vindo Usuário'),
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Theme.of(context).colorScheme.onSecondary,
            centerTitle: true,
          ),
          // Divider(),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(
              Icons.shopping_basket_outlined,
              size: 30,
              color: Colors.blue,
            ),
            title: const Text('Loja'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.AUTH_HOME);
            },
          ),
          const Divider(
            indent: 15,
            endIndent: 15,
            color: Colors.purple,
          ),
          ListTile(
            leading: const Icon(
              Icons.payment,
              color: Colors.blueAccent,
            ),
            title: const Text('Pedidos'),
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.ORDERS);
            },
          ),
          const Divider(
            indent: 15,
            endIndent: 15,
            color: Colors.purple,
          ),
          ListTile(
            leading: const Icon(
              Icons.edit,
              color: Colors.blueAccent,
            ),
            title: const Text('Gerenciar Produtos'),
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.PRODUCTS);
            },
          ),
          const Divider(
            indent: 15,
            endIndent: 15,
            color: Colors.purple,
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.blueAccent,
            ),
            title: const Text('Sair'),
            onTap: () {
              Provider.of<Auth>(context, listen: false).logout();
              Navigator.popAndPushNamed(context, AppRoutes.AUTH_HOME);
            },
          )
        ],
      ),
    );
  }
}
