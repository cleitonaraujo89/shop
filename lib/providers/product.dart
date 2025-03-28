import 'package:flutter/material.dart';

class Product with ChangeNotifier{
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false
  });

  //altera o estado de favorito do produto e notivifa os ouvintes
  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

}