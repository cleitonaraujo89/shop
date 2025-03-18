import 'package:flutter/material.dart';
import 'package:shop/providers/cart.dart';

class WidgetCartItem extends StatelessWidget {
  const WidgetCartItem(this.cartItem, {super.key});

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ListTile(
            leading: CircleAvatar(
              maxRadius: 30,
              backgroundImage: NetworkImage(cartItem.imageUrl),
            ),
            title: Text(cartItem.title),
            subtitle: Text('Total: R\$${cartItem.price * cartItem.quantity}'),
            trailing: Text('${cartItem.quantity}x')),
      ),

      // Text(cartItem.title),
      // Spacer(),
      // IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
      // IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
    );
  }
}
