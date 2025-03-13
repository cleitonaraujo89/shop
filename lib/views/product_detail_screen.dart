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

    final Product product = ModalRoute.of(context)?.settings.arguments as Product;
    return BaseScaffold(
      title: product.title,
      body: Text('test'),
    );
  }
}
