// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../components/base_scaffold.dart';
import '../providers/product.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  // const ProductDetailScreen({super.key, required this.product});

  // final Product product;

  @override
  Widget build(BuildContext context) {
    final Product product =
        ModalRoute.of(context)?.settings.arguments as Product;
    return BaseScaffold(
      title: product.title,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              //o Hero é um efeito de animação, na tag temos q por algo semelhante
              //na imagem de origem e de destino (aqui e no product_grid_item)
              child: Hero(
                tag: product.id!,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'R\$${product.price}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                product.description,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
