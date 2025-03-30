// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_list.dart';
import '../providers/product.dart';

Future<void> saveProductForm(
  BuildContext context,
  GlobalKey<FormState> formKey,
  Map<String, Object> formData,
  TextEditingController imageUrlController,
) async {
  // Validação do formulário
  //checa se o formulario é válido, lembrando que _form é a key do formulário
  final bool isValid = formKey.currentState!.validate();
  //se nao estriver válido n salva.
  if (!isValid) {
    return;
  }

  //Acessa o estado atual do formulário (Form) e chama o onSaved de cada TextTextFormField
  formKey.currentState!.save();

  final newProduct = Product(
    id: formData['id'] != null ? formData['id'] as String : null,
    title: formData['title'] as String,
    description: formData['description'] as String,
    price: formData['price'] as double,
    imageUrl: formData['imageUrl'] as String,
  );

  //variável de texto adaptativo para msg de confirmação
  String adaptativeText;
  try {
    if (formData['id'] == null) {
      Provider.of<ProductsList>(context, listen: false).addProduct(newProduct).then((_) {
        
      });
      adaptativeText = 'Adicionado';
    } else {
      Provider.of<ProductsList>(context, listen: false)
          .updateProduct(newProduct);
      adaptativeText = 'Atualizado';
    }

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Center(child: Text('Prontinho!')),
        content: Text('Produto $adaptativeText com Sucesso!'),
        actions: [
          //como a função é await vai esperar o click do usuário para fechar o Dialog
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );

    //e depois vai fechar a tela de formulário
    Navigator.of(context).pop();
  } catch (e) {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Center(child: Text('Erro!!')),
        content: Text(
          'O Produto não foi salvo: ${e.toString()}, Refaça a operação!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}

Future<void> deleteProduct({
  required BuildContext context,
  required String productID,
  required String productTitle,
  required String imageUrl,
}) async {
  await showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Center(child: Text('Tem Certeza?')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Deseja excluir este produto ?'),
          SizedBox(
            height: 15,
          ),
          Text(productTitle),
          SizedBox(
            height: 15,
          ),
          Center(
            child: SizedBox(
              height: 100,
              width: 100,
              child: FittedBox(
                fit: BoxFit.cover,
                child: Image.network(imageUrl),
              ),
            ),
          )
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Voltar'),
            ),
            TextButton(
              onPressed: () {
                final bool deletedItem =
                    Provider.of<ProductsList>(context, listen: false)
                        .deleteProduct(productID: productID);

                if (deletedItem) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Produto Removido!',
                        style: TextStyle(fontSize: 18),
                      ),
                      duration: Duration(seconds: 3),
                    ),
                  );
                } else {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Falha na remoção do produto!',
                        style: TextStyle(fontSize: 18),
                      ),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
              child: Text('Deletar'),
            ),
          ],
        ),
      ],
    ),
  );
}
