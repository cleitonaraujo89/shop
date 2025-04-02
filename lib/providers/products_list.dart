//   https://cdn.pixabay.com/photo/2019/06/30/21/08/balloon-4308798_640.png
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'product.dart';
//import '../data/dummy_data.dart';
import '../config/firebase_config.dart';

class ProductsList with ChangeNotifier {
  final List<Product> _items = [];
  final String _url = FirebaseConfig.urlProducts;

  List<Product> get items {
    return [..._items];
  }

  int get itensCount {
    return _items.length;
  }

  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  // ---------------- CARREGA A LISTA DE PRODUTOS -----------
  Future<void> loadProducts() async {
    final response = await http.get(Uri.parse('$_url.json'));

    if (response.statusCode >= 400) {
      throw Exception('Erro ao receber dados: ${response.body}');
    }

    //se n tiver produtos... return
    if (response.body.isEmpty || response.body == "null") {
      return;
    }

    Map<String, dynamic> data = jsonDecode(response.body);

    //limpa a lista para que não haja duplicação da lista toda vez que carregar a pagina.
    _items.clear();

    //para cada item em data vai pegar o is e os dados do produto (key, value) e adicionar a lista de produtos
    data.forEach((productId, productData) {
      _items.add(Product(
        id: productId,
        title: productData['title'],
        price: productData['price'],
        description: productData['description'],
        imageUrl: productData['imageUrl'],
        isFavorite: productData['isFavorite'],
      ));
    });

    notifyListeners();
    return Future.value();
  }

  //  ------- ADIÇÃO DE PRODUTO ---------
  Future<void> addProduct(Product newProduct) async {
    final String idRandom = Random().nextDouble().toString();

    //se já tiver o ID lança o erro
    if (_items.any((p) => p.id == idRandom)) {
      throw Exception("ID já existente.");
    }

    try {
      final response = await http.post(Uri.parse('$_url.json'),
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

  //  ------------ ATUALIZAÇÃO DE PRODUTO ---------------------
  Future<void> updateProduct(Product updatedProduct) async {
    if (updatedProduct.id == null) {
      return;
    }

    //atribui o index da lista aonde o id de oldProduct for igual a algum id já existente.
    //caso não encontre atribuirá o valor -1
    final index = _items.indexWhere((prod) => prod.id == updatedProduct.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse("$_url/${updatedProduct.id}.json"),
        body: json.encode({
          'title': updatedProduct.title,
          'price': updatedProduct.price,
          'description': updatedProduct.description,
          'imageUrl': updatedProduct.imageUrl,
        }),
      );
      //atualiza a lista sem precisar carregar novamente
      _items[index] = updatedProduct;
      notifyListeners();
    }
  }

  // ----------- DELETAR PRODUTO -------------------
  Future<bool> deleteProduct({required String productID}) async {
    final index = _items.indexWhere((prod) => prod.id == productID);

    if (index >= 0) {
      final response = await http.delete(Uri.parse("$_url/$productID.json"));

      if (response.statusCode >= 400) {
        return false;
      }

      _items.removeAt(index);
      notifyListeners();

      return true;
    }

    //se n achar o ID
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
