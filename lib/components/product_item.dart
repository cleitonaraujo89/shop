import 'package:flutter/material.dart';
import '../providers/product.dart';
import '../utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      //subtitle: Text(product.description),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.PRODUCTS_FORM, 
                arguments: product,
                );
              },
              icon: Icon(Icons.edit,
                  color: Theme.of(context).colorScheme.primary),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.error.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
