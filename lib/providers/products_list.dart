import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'product.dart';
import '../data/dummy_data.dart';
import '../config/firebase_config.dart';

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
  Future<void> addProduct(Product newProduct) async {
    final String idRandom = Random().nextDouble().toString();

    //se já tiver o ID lança o erro
    if (_items.any((p) => p.id == idRandom)) {
      throw Exception("ID já existente.");
    }
    //https://cdn.pixabay.com/photo/2019/06/30/21/08/balloon-4308798_640.png
    const String url = '${FirebaseConfig.dataBaseUrl}products';

    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'title': newProduct.title,
            'price': newProduct.price,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'isFavorite': newProduct.isFavorite,
          }));

      if (response.statusCode >= 400) {
        throw Exception('Erro ao enviar dados: ${response.body}');
      }

      _items.add(Product(
        //response.body é uma string JSON.
        //jsonDecode(response.body) transforma essa string JSON em um mapa (Map<String, dynamic>).
        //['name'] acessa a chave "name" dentro do mapa retornado.
        id: jsonDecode(response.body)['name'],
        title: newProduct.title,
        price: newProduct.price,
        description: newProduct.description,
        imageUrl: newProduct.imageUrl,
      ));
      notifyListeners();
    } catch (error) {
      if (error.toString().startsWith('Erro ao enviar')) {
        throw Exception(error.toString());
      } else {
        throw Exception('Falha na execução, por favor refaça a operação');
      }
    }
  }

  void updateProduct(Product updatedProduct) {
    if (updatedProduct.id == null) {
      return;
    }

    //atribui o index da lista aonde o id de oldProduct for igual a algum id já existente.
    //caso não encontre atribuirá o valor -1
    final index = _items.indexWhere((prod) => prod.id == updatedProduct.id);

    if (index >= 0) {
      _items[index] = updatedProduct;
      notifyListeners();
    }
  }

  bool deleteProduct({required String productID}) {
    final index = _items.indexWhere((prod) => prod.id == productID);

    if (index >= 0) {
      _items.removeAt(index);
      notifyListeners();

      return true;
    }

    return false;
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
