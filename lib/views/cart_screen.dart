// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/base_scaffold.dart';
import 'package:shop/components/widget_cart_item.dart';
import '../providers/cart.dart';
import '../providers/orders.dart';
import '../components/alert.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of(context);
    final cartItems = cart.items.values.toList();

    return BaseScaffold(
      title: 'Carrinho',
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(25),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Text(
                        'R\$ ${cart.totalAmout}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(), //cria um espaço entre os elementos
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (ctx, i) => WidgetCartItem(cartItems[i]),
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    super.key,
    required this.cart,
  });

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      //desabilitando o botão para evitar requisições vazias
      onPressed: widget.cart.totalAmout == 0
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              try {
                await Provider.of<Orders>(context, listen: false)
                    .addOrder(widget.cart);
                setState(() {
                  _isLoading = false;
                });

                widget.cart.clear();
              } catch (e) {
                alert(
                    context: context,
                    title: 'Oops',
                    content: 'Algo deu errado, tente novamente');
              }
            },
      child:
          _isLoading ? const CircularProgressIndicator.adaptive() : const Text('COMPRAR'),
    );
  }
}
