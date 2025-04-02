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

  //altera o estado de favorito do produto e notivifa os ouvintes
  Future<void> toggleFavorite() async {
    isFavorite = !isFavorite;
    notifyListeners();

    try {
      final response = await http.patch(
        Uri.parse('${FirebaseConfig.urlProducts}/$id.json'),
        body: json.encode({
          'id': id,
          'title': title,
          'price': price,
          'description': description,
          'imageUrl': imageUrl,
          'isFavorite': isFavorite,
        }),
      );

      if (response.statusCode >= 400) {
        throw Exception();
      }
    } catch (e) {
      isFavorite = !isFavorite;
      notifyListeners();

      throw Exception();
    }
  }
}
