import 'package:flutter/material.dart';
import 'package:shop/components/base_scaffold.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(title: 'Meus Pedidos', body: Text('tela de pedidos'));
  }
}