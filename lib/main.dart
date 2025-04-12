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

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          //vazia pois o construtor de PL esta com os atributos opcionais '[]'
          create: (_) => ProductsList(),
          //essa função abaixo sempre é chamada quando Auth Atualiza
          //resumindo a gente cria PL vazia, e atualiza passando o token
          //previousProducts é a instância anterior de ProductsList (ou null se n tiver)
          update: (ctx, auth, previousProducts) => ProductsList(
              auth.token, previousProducts?.items ?? [], auth.userId),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          //quando não deixamos como os atributos como opcionais...
          create: (_) => Orders(null, [], null),
          update: (context, auth, previousOrders) => Orders(
            auth.token,
            previousOrders?.getOrders ?? [],
            auth.userId
          ),
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
            textTheme: const TextTheme(titleLarge: TextStyle())),
        //home: AuthScreen(),
        routes: {
          AppRoutes.AUTH_HOME: (ctx) => const AuthOrHomeScreen(),
          AppRoutes.PRODUCT_DETAIL: (ctx) => const ProductDetailScreen(),
          AppRoutes.CART: (ctx) => const CartScreen(),
          AppRoutes.ORDERS: (ctx) => const OrdersScreen(),
          AppRoutes.PRODUCTS: (ctx) => const ProductsManagementScreen(),
          AppRoutes.PRODUCTS_FORM: (ctx) => const ProductFormScreen(),
        },
      ),
    );
  }
}
