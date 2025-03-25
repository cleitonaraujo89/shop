// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop/components/base_scaffold.dart';
import '../components/app_drawer.dart';
import '../components/product_item.dart';
import '../utils/app_routes.dart';

import '../providers/products_list.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsList>(context);
    final products = productsData.items;

    return BaseScaffold(
      title: 'Gerenciar Produtos',
      drawer: const AppDrawer(),
      action: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.PRODUCTS_FORM);
          },
          icon: const Icon(Icons.add),
        )
      ],
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: productsData.itensCount,
          itemBuilder: (ctx, i) => Column(
            children: [
              ProductItem(product: products[i]),
              Divider(
                thickness: 3,
                endIndent: 10,
                indent: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
