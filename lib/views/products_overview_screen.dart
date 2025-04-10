// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, sort_child_properties_last, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/utils/app_routes.dart';

import '../providers/cart.dart';
import '../providers/products_list.dart';

import '../components/base_scaffold.dart';
import '../components/product_grid.dart';
import '../components/badge.dart' as cart_badge;
import '../components/app_drawer.dart';
import '../components/alert.dart';

enum FilterOptions { favorite, all }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavoriteOnly = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductsList>(context, listen: false).loadProducts().then((_) {
      setState(() {
        _isLoading = false;
      });
    }).catchError((e) {
      alert(
          context: context,
          title: 'Oops algo deu errado!',
          content: 'Por favor tente novamente. ${e.toString()}');
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator.adaptive())
          : ProductGrid(showFavoriteOnly: _showFavoriteOnly),
      drawer: AppDrawer(),
    );
  }
}
