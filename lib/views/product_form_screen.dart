// ignore_for_file: prefer_const_constructors

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
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //adiciona um ouvinte para executar a função sempre que ouver uma mudança no estado do FocusNode
    _imageUrlFocusNode.addListener(_updateImage);
  }

  void _updateImage() {
    setState(() {});
  }

  //O dispose serve para evitar memory leaks (vazamento de memória), é execucado quando o widget sai da árvore de widgets.
  //Objetos como FocusNode, TextEditingController, AnimationController, timers e streams precisam ser descartados manualmente quando a tela é destruída. Caso contrário, continuam ocupando memória.
  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descritionFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImage);
    _imageUrlFocusNode.dispose();
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
                  FocusScope.of(context).requestFocus(_imageUrlFocusNode);
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    //precisa de um espaço definido para mostrar o campo do formulário, por isso o expanded
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'URL da Imagem'),
                      keyboardType: TextInputType.url,
                      //submet o formulário
                      textInputAction: TextInputAction.done,
                      focusNode: _imageUrlFocusNode,
                      controller: _imageUrlController,
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(top: 8, left: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Informe a URL')
                        : FittedBox(
                            fit: BoxFit.cover,
                            child: Image.network(_imageUrlController.text),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
