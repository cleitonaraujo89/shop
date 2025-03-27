import 'dart:math';

import 'package:flutter/material.dart';
import 'product.dart';
import '../data/dummy_data.dart';

class ProductsList with ChangeNotifier {
  final List<Product> _items = DUMMY_PRODUCTS;

  List<Product> get items {
    return [..._items];
  }

  int get itensCount {
    return _items.length;
  }

  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  //adiciona um produto e notifica os ouvintes
  void addProduct(Product newProduct) {
    final String idRandom = Random().nextDouble().toString();

    //se já tiver o ID lança o erro
    if (_items.any((p) => p.id == idRandom)) {
      throw Exception("ID já existente.");
    }

    _items.add(Product(
      id: idRandom,
      title: newProduct.title,
      price: newProduct.price,
      description: newProduct.description,
      imageUrl: newProduct.imageUrl,
    ));
    notifyListeners();
  }
}

 //itens comentados pois o gerenciamento de estado sobre os favoritos 
  //foi transferido para ProductsOverviewScreen

  //bool _FavoriteOnly = false;

  //usado para proteger os dados da lista original
  // List<Product> get items {
  //   if (_FavoriteOnly) {
  //     return _items.where((prod) => prod.isFavorite).toList();
  //   }

  //   return [..._items];
  // }

  // void showFavoriteOnly() {
  //   _FavoriteOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _FavoriteOnly = false;
  //   notifyListeners();
  // }
