import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop/components/base_scaffold.dart';
import '../components/app_drawer.dart';
import '../components/product_item.dart';
import '../utils/app_routes.dart';

import '../providers/products_list.dart';

class ProductsManagementScreen extends StatelessWidget {
  const ProductsManagementScreen({super.key});

  Future<void> _refreshProducts(BuildContext context) async {
    return await Provider.of<ProductsList>(context, listen: false)
        .loadProducts();
  }

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
      body: RefreshIndicator.adaptive(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: productsData.itensCount,
            itemBuilder: (ctx, i) => Column(
              children: [
                ProductItem(product: products[i]),
                const Divider(
                  thickness: 3,
                  endIndent: 10,
                  indent: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
