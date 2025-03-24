import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop/components/base_scaffold.dart';
import '../components/app_drawer.dart';
import '../providers/products_list.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsList>(context);
    return BaseScaffold(
      title: 'Gerenciar Produtos',
      drawer: AppDrawer(),
      action: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.add),
        )
      ],
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: products.itensCount,
          itemBuilder: (ctx, i) => Text('Testando'),
        ),
      ),
    );
  }
}
