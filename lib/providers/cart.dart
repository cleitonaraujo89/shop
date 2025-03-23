import 'dart:math';

import 'package:flutter/material.dart';
import '../providers/product.dart';

class CartItem {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;
  final String imageUrl;

  const CartItem({
    required this.id,
    required this.productId,
    required this.title,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });
}

class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemsCount {
    return _items.length;
  }

  //adciona produtos ao carrinho
  void addItem(Product product) {
    //checa se o produto já existe no carrinho
    if (_items.containsKey(product.id)) {
      _items.update(product.id, (existingItem) {
        return CartItem(
          id: existingItem.id,
          productId: existingItem.productId,
          title: existingItem.title,
          quantity: existingItem.quantity + 1,
          price: existingItem.price,
          imageUrl: existingItem.imageUrl,
        );
      });
    } else {
      _items.putIfAbsent(
        product
            .id, //define a chave e abaixo o valor (objeto) <String, CartItem>
        () => CartItem(
          id: Random().nextDouble().toString(),
          productId: product.id,
          title: product.title,
          quantity: 1,
          price: product.price,
          imageUrl: product.imageUrl,
        ),
      );
    }

    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    //se nao terver o produto (a chave) retorna
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId]!.quantity == 1) {
      _items.remove(productId);
    } else {
      _items.update(productId, (existingItem) {
        return CartItem(
          id: existingItem.id,
          productId: existingItem.productId,
          title: existingItem.title,
          quantity: existingItem.quantity - 1,
          price: existingItem.price,
          imageUrl: existingItem.imageUrl,
        );
      });
    }

    notifyListeners();
  }

  //retorna o valor dos produtos no carrinho
  double get totalAmout {
    double total = _items.values.fold(0.0, (total, cartItem) {
      return total + (cartItem.price * cartItem.quantity);
    });

    return double.parse(total.toStringAsFixed(2)); //limita a 2 casas decimais
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
