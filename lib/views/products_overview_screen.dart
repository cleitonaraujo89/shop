// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/utils/app_routes.dart';
import '../components/base_scaffold.dart';
import '../components/product_grid.dart';
//import '../providers/products_provider.dart';
import '../providers/cart.dart';
import '../components/badge.dart' as cart_badge;

enum FilterOptions { favorite, all }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavoriteOnly = false;

  @override
  Widget build(BuildContext context) {
    //final ProductsProvider products = Provider.of(context);
    //final Cart cart = Provider.of<Cart>(context);

    return BaseScaffold(
      title: 'Minha Loja',
      action: [
        PopupMenuButton(
          icon: Icon(Icons.more_vert),
          onSelected: (FilterOptions selectedValue) {
            setState(() {
              if (selectedValue == FilterOptions.favorite) {
                _showFavoriteOnly = true;
                //products.showFavoriteOnly();
              } else {
                _showFavoriteOnly = false;
                //products.showAll();
              }
            });
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              child: Text('Somente Favoritos'),
              value: FilterOptions.favorite,
            ),
            PopupMenuItem(
              child: Text('Todos'),
              value: FilterOptions.all,
            ),
          ],
        ),
        //usando alias para evitar erro de importação
        Consumer<Cart>(
          child: IconButton(
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.CART),
            icon: Icon(Icons.shopping_cart),
          ),
          builder: (_, cart, child) => cart_badge.Badge(
            value: cart.itemsCount.toString(),
            child: child!,
          ),
        ),
      ],
      body: ProductGrid(
        showFavoriteOnly: _showFavoriteOnly,
      ),
    );
  }
}
