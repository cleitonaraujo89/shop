// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'views/products_overview_screen.dart';
import 'utils/app_routes.dart';
import './views/product_detail_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailScreen()
      },
    );
  }
}
