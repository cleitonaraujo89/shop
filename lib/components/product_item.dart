import 'package:flutter/material.dart';
import '../providers/product.dart';
import '../utils/app_routes.dart';
import '../utils/products_form_utills.dart';

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
                Navigator.of(context).pushNamed(
                  AppRoutes.PRODUCTS_FORM,
                  arguments: product,
                );
              },
              icon: Icon(Icons.edit,
                  color: Theme.of(context).colorScheme.primary),
            ),
            IconButton(
              onPressed: () {
                deleteProduct(
                  context: context,
                  productID: product.id as String,
                  productTitle: product.title,
                  imageUrl: product.imageUrl,
                );
              },
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
