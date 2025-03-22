import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/base_scaffold.dart';
import '../components/app_drawer.dart';
import '../providers/orders.dart';
import '../components/order_widget.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Orders orders = Provider.of<Orders>(context);
    return BaseScaffold(
      title: 'Meus Pedidos',
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: orders.ordersCount,
        itemBuilder: (ctx, i) => OrderWidget(order: orders.getOrders[i]),
      ),
    );
  }
}
