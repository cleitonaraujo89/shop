import 'dart:math';

import 'package:flutter/material.dart';
import '../providers/product.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  const CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  //adciona produtos ao carrinho
  void addItem(Product product) {
    //checa se o produto já existe no carrinho
    if (_items.containsKey(product.id)) {
      _items.update(product.id, (existingItem) {
        return CartItem(
          id: existingItem.id,
          title: existingItem.title,
          quantity: existingItem.quantity + 1,
          price: existingItem.price,
        );
      });
    } else {
      _items.putIfAbsent(
        product.id, //define a chave e abaixo o valor (objeto) <String, CartItem>
        () => CartItem(
          id: Random().nextDouble().toString(),
          title: product.title,
          quantity: 1,
          price: product.price,
        ),
      );
    }

    notifyListeners();
  }

  //retorna o valor dos produtos no carrinho
  double get totalAmout {    
    return _items.values.fold(0.0, (total, cartItem) {
      return  total + (cartItem.price * cartItem.quantity);      
    });
  }
}
