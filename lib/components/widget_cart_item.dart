import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';

class WidgetCartItem extends StatelessWidget {
  const WidgetCartItem(this.cartItem, {super.key});

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    //deleta o item arrastando para o lado
    return Dismissible(
      key: ValueKey(cartItem.id),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_){
        Provider.of<Cart>(context, listen: false).removeItem(cartItem.productId);
      },
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListTile(
              leading: CircleAvatar(
                maxRadius: 30,
                backgroundImage: NetworkImage(cartItem.imageUrl),
              ),
              title: Text(cartItem.title),
              subtitle: Text(
                  'Total: R\$${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}'),
              trailing: Text('${cartItem.quantity}x')),
        ),

        // Text(cartItem.title),
        // Spacer(),
        // IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
        // IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
      ),
    );
  }
}
