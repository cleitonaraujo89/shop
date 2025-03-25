import 'package:flutter/material.dart';

import '../components/base_scaffold.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceFocusNode = FocusNode();
  final _descritionFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descritionFocusNode.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Formulário Produto',
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(label: Text('Titulo')),
                //altera o botão do teclado do usuario para Next ao inves do subimit
                textInputAction: TextInputAction.next,
                //quando o usuario clica no subimit o foco do formulário muda para o campo preço
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
              ),
              TextFormField(
                decoration: InputDecoration(label: Text('Preço')),
                textInputAction: TextInputAction.next,
                //indicação do foco
                focusNode: _priceFocusNode,
                //teclado numérico
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                //muda o foco para o campo descrição
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descritionFocusNode);
                },
              ),
              TextFormField(
                decoration: InputDecoration(label: Text('Descrição')),
                //maximo de linhas
                maxLines: 3,
                //teclado adaptado para o usuario poder pular de linha, remoção do textInputAction
                keyboardType: TextInputType.multiline,
                focusNode: _descritionFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
