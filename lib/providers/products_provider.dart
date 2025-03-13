import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/dummy_data.dart';

class ProductsProvider with ChangeNotifier {
  final List<Product> _items = DUMMY_PRODUCTS;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  //adiciona um produto e notifica os ouvintes
  void addProduct(Product product) {
    _items.add(product);
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
