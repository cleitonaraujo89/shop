import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/base_scaffold.dart';
import '../components/app_drawer.dart';
import '../providers/orders.dart';
import '../components/order_widget.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isLoading = true;

  Future<void> _refreshProducts(BuildContext context) async {
    return await Provider.of<Orders>(context, listen: false).loadOrders();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<Orders>(context, listen: false).loadOrders().then((_) {
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Orders orders = Provider.of<Orders>(context);
    return BaseScaffold(
      title: 'Meus Pedidos',
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : RefreshIndicator.adaptive(
              onRefresh: () => _refreshProducts(context),
              child: ListView.builder(
                itemCount: orders.ordersCount,
                itemBuilder: (ctx, i) =>
                    OrderWidget(order: orders.getOrders[i]),
              ),
            ),
    );
  }
}
