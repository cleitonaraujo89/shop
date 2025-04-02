import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop/providers/cart.dart';
import '../config/firebase_config.dart';
import 'package:http/http.dart' as http;

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
  final String _urlOrders = FirebaseConfig.urlOrders;
  final List<Order> _orders = [];

  List<Order> get getOrders {
    return [..._orders];
  }

  int get ordersCount {
    return _orders.length;
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();

    final responseAdd = await http.post(
      Uri.parse('$_urlOrders.json'),
      body: json.encode({
        'total': cart.totalAmout,
        'date': date.toIso8601String(),
        'products': cart.items.values
            .map((cartItem) => {
                  'id': cartItem.id,
                  'productId': cartItem.productId,
                  'title': cartItem.title,
                  'quantity': cartItem.quantity,
                  'price': cartItem.price,
                  'imageUrl': cartItem.imageUrl,
                })
            .toList(),
      }),
    );

    final String idDB = jsonDecode(responseAdd.body)['name'];
    _orders.insert(
        0, //adiciona o novo pedido no inicio da lista movendo os outros para trás
        Order(
          id: idDB,
          total: cart.totalAmout,
          products: cart.items.values.toList(),
          date: date,
        ));

    notifyListeners();

    final responseUpdt = await http.patch(
      Uri.parse('$_urlOrders/$idDB.json'),
      body: jsonEncode({'id': idDB}),
    );

    if (responseAdd.statusCode >= 400 || responseUpdt.statusCode >= 400) {
      _orders.removeAt(0);
      notifyListeners();
      throw Exception();
    }
  }
}
