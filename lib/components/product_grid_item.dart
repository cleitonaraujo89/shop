// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/product.dart';
import '../utils/app_routes.dart';
import '../providers/cart.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem({super.key});

  @override
  Widget build(BuildContext context) {
    //recebe o produto passado pelo privider acima (product_grid)
    //listen false para n reconstruir o objetto inteiro quando atualizado
    final Product product = Provider.of(context, listen: false);
    final Cart cart = Provider.of(context, listen: false);
    final Auth auth = Provider.of(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,

          //um ouvinte que atualiza um ponto específico desta forma
          // n reconstroi o widget inteiro, somente o q foi alterado
          //atentar que não referencia diretamente o product acima
          leading: Consumer<Product>(
            builder: (ctx, productConsumer, _) => IconButton(
              onPressed: () async {
                //ao mudar o estado do favorito altera o icone
                try {
                  await productConsumer.toggleFavorite(
                      auth.token ?? '', auth.userId ?? '');
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Erro ao Favoritar, tente novamente!',
                        style: TextStyle(fontSize: 18),
                      ),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
              icon: Icon(productConsumer.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border),
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            onPressed: () {
              //fecha qualquer SnackBar aberta
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              //depois abre uma SnackBar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Produto adicionado!',
                    style: TextStyle(fontSize: 18),
                  ),
                  duration: const Duration(seconds: 3),
                  action: SnackBarAction(
                      label: 'DESFAZER',
                      onPressed: () {
                        cart.removeSingleItem(product.id!);
                      }),
                ),
              );
              cart.addItem(product);
            },
            icon: const Icon(Icons.shopping_cart),
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.PRODUCT_DETAIL,
              arguments: product,
            );
          },
          //o Hero é um efeito de animação, na tag temos q por algo semelhante
          //na imagem de origem e de destino (aqui e na product_detal_screen)
          child: Hero(
            tag: product.id!,
            child: FadeInImage(
              placeholder:
                  const AssetImage('assets/images/8.1 product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
