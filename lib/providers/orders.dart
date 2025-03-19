import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/providers/cart.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime date;

  const Order(
      {required this.id,
      required this.total,
      required this.products,
      required this.date});
}

class Orders with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> products, double total) {
    _orders.insert(
        0,
        Order(
          id: Random().nextDouble().toString(),
          total: total,
          products: products,
          date: DateTime.now(),
        ));
        
    notifyListeners();
  }
}
