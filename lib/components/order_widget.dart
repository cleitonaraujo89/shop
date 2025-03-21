import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders.dart';

class OrderWidget extends StatelessWidget {
  const OrderWidget({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        title: Text('R\$ ${order.total}'),
        subtitle: Text(DateFormat('dd / MM / yyyy - hh:mm').format(order.date)),
        trailing: IconButton(onPressed: () {}, icon: Icon(Icons.expand_more)),
      ),
    );
  }
}
