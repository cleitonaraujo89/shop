// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_list.dart';
import '../providers/product.dart';
import '../components/alert.dart';

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
  // String adaptativeText;
  try {
    if (formData['id'] == null) {
      await Provider.of<ProductsList>(context, listen: false)
          .addProduct(newProduct);

      await alert(
        context: context,
        title: 'Sucesso!',
        content: 'Produto Adicionado!',
      );

      Navigator.of(context).pop();
    } else {
      await Provider.of<ProductsList>(context, listen: false)
          .updateProduct(newProduct);

      await alert(
        context: context,
        title: 'Sucesso!',
        content: 'Produto Atualizado!',
      );

      Navigator.of(context).pop();
    }
  } catch (e) {
    alert(context: context, title: 'Oops!', content: 'Tivemos um erro');
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
    builder: (ctx) {
      bool loading = false;

      return StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Center(child: Text('Tem Certeza?')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Deseja excluir este produto ?'),
              loading
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : const SizedBox(height: 36),
              const SizedBox(
                height: 15,
              ),
              Text(productTitle),
              const SizedBox(
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
                  child: const Text('Voltar'),
                ),
                TextButton(
                  onPressed: () async {
                    setState(() => loading = true);
                    final bool deletedItem =
                        await Provider.of<ProductsList>(context, listen: false)
                            .deleteProduct(productID: productID);

                    if (deletedItem) {
                      setState(() => loading = false);
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Produto Removido!',
                            style: TextStyle(fontSize: 18),
                          ),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    } else {
                      setState(() => loading = false);
                      alert(
                          context: context,
                          title: 'Oops!',
                          content: 'falha na remoção do item');
                    }
                  },
                  child: const Text('Deletar'),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
