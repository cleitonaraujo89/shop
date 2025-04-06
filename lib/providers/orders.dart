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

  Orders(this._token, this._orders);

  final String? _token;
  final String _urlOrders = FirebaseConfig.urlOrders;
  final List<Order> _orders;

  List<Order> get getOrders {
    return [..._orders];
  }

  int get ordersCount {
    return _orders.length;
  }

  //  --------------- ADIÇÃO DE PEDIDOS -------------
  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();

    final responseAdd = await http.post(
      Uri.parse('$_urlOrders.json?auth=$_token'),
      body: json.encode({
        'total': cart.totalAmout,
        //deste modo fica melhor para formatar depois
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
      Uri.parse('$_urlOrders/$idDB.json?auth=$_token'),
      body: jsonEncode({'id': idDB}),
    );

    if (responseAdd.statusCode >= 400 || responseUpdt.statusCode >= 400) {
      _orders.removeAt(0);
      notifyListeners();
      throw Exception();
    }
  }

  //  ----------- CARREGAR PEDIDOS -----------
  Future<void> loadOrders() async {
    final response = await http.get(Uri.parse('$_urlOrders.json?auth=$_token'));

    if (response.statusCode >= 400) {
      throw Exception('Erro ao receber dados: ${response.body}');
    }

    //se n tiver produtos... return
    if (response.body.isEmpty || response.body == "null") {
      return;
    }

    Map<String, dynamic> data = jsonDecode(response.body);

    _orders.clear();

    data.forEach((orderId, orderData) {

      _orders.insert(
        0,
        Order(
          id: orderId,
          total: orderData['total'],
          date: DateTime.parse(orderData['date']),
          //Em Order products é uma lista <CartItem>
          products: (orderData['products'] as List<dynamic>).map((item) {
            return CartItem(
              id: item['id'],
              productId: item['productId'],
              title: item['title'],
              quantity: item['quantity'],
              price: item['price'],
              imageUrl: item['imageUrl'],
            );
          }).toList(),
        ),
      );
    });
    notifyListeners();
    return Future.value();
  }
}
