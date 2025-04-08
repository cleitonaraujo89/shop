import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/firebase_config.dart';

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});

  //altera o estado de favorito do produto e notifica os ouvintes
  Future<void> toggleFavorite(String token, String userId) async {
    isFavorite = !isFavorite;
    notifyListeners();

    try {
      //cria no fb dentro de userFavorites a chave com o id do produto e o valor do isFavorite
      final response = await http.put(
        Uri.parse(
            '${FirebaseConfig.userFavorites}/$userId/$id.json?auth=$token'),
        body: json.encode(isFavorite),
      );

      if (response.statusCode >= 400) {
        throw Exception();
      }
      // caso algo dê errado volta a condição inicial
    } catch (e) {
      isFavorite = !isFavorite;
      notifyListeners();

      throw Exception();
    }
  }
}
