// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders.dart';
import 'utils/app_routes.dart';
import 'package:shop/views/cart_screen.dart';
import 'views/products_overview_screen.dart';
import './views/product_detail_screen.dart';
import './providers/products_provider.dart';
import './providers/cart.dart';
import './views/orders_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
        create: (_) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
        create: (_) => Cart(),
        ),
         ChangeNotifierProvider(
        create: (_) => Orders(),
        ),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Minha Loja',
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple).copyWith(
              secondary: Colors.deepOrange,
            ),
            fontFamily: 'Lato',
            textTheme: TextTheme(titleLarge: TextStyle())),
        home: ProductsOverviewScreen(),
        routes: {
          AppRoutes.HOME: (ctx) => ProductsOverviewScreen(),
          AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailScreen(),
          AppRoutes.CART: (ctx) => CartScreen(),
          AppRoutes.ORDERS: (ctx) => OrdersScreen(),
        },
      ),
    );
  }
}
