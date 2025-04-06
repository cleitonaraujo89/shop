// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './utils/app_routes.dart';

import './providers/cart.dart';
import './providers/orders.dart';
import './providers/products_list.dart';
import './providers/auth.dart';

import './views/cart_screen.dart';
import './views/product_detail_screen.dart';
import './views/orders_screen.dart';
import './views/products_management_screen.dart';
import './views/product_form_screen.dart';
import './views/auth_home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //existe uma hierarquia nos providers, funciona de acordo com a ordem de declaração
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        //passa os dados de um provider para o outro
        ChangeNotifierProxyProvider<Auth, ProductsList>(
          //cria o provider ProductsList que depende de Auth, sempre q Auth mudar
          //ProductsList sera atualizado, abaixo criamos a instancia incial de PL
          create: (_) => ProductsList(null, []),
          //essa função abaixo sempre é chamada quando Auth Atualiza
          //resumindo a gente cria PL vazia, e atualiza passando o token
          //previousProducts é a instância anterior de ProductsList (ou null se n tiver)
          update: (ctx, auth, previousProducts) => ProductsList(
            auth.token,
            previousProducts?.items ?? [],
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders(null, []),
          update: (context, auth, previousOrders) =>
              Orders(auth.token, previousOrders?.getOrders ?? []),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Minha Loja',
        theme: ThemeData(
            useMaterial3: true,
            colorScheme:
                ColorScheme.fromSeed(seedColor: Colors.purple).copyWith(
              secondary: Colors.deepOrange,
            ),
            fontFamily: 'Lato',
            textTheme: TextTheme(titleLarge: TextStyle())),
        //home: AuthScreen(),
        routes: {
          AppRoutes.AUTH_HOME: (ctx) => AuthOrHomeScreen(),
          AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailScreen(),
          AppRoutes.CART: (ctx) => CartScreen(),
          AppRoutes.ORDERS: (ctx) => OrdersScreen(),
          AppRoutes.PRODUCTS: (ctx) => ProductsManagementScreen(),
          AppRoutes.PRODUCTS_FORM: (ctx) => ProductFormScreen(),
        },
      ),
    );
  }
}
