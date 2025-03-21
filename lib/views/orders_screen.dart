import 'package:flutter/material.dart';
import 'package:shop/components/base_scaffold.dart';
import '../components/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseScaffold(
      title: 'Meus Pedidos',
      body: Text('tela de pedidos'),
      drawer: AppDrawer(),
    );
  }
}
