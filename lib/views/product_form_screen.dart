// ignore_for_file: prefer_const_constructors, prefer_collection_literals

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../components/base_scaffold.dart';
import '../providers/products_list.dart';
import '../providers/product.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  //variaveis para checagem do que é digitadopelo usuário
  String? titleError;
  String? priceError;
  String? descriptionError;
  String? urlError;
  //variaveis para controle do foco
  final _priceFocusNode = FocusNode();
  final _descritionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  //variaveis para controller e valores oriundos do formulário
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  @override
  void initState() {
    super.initState();
    //adiciona um ouvinte para executar a função sempre que ouver uma mudança no estado do FocusNode
    _imageUrlFocusNode.addListener(_updateImage);
  }

  void _updateImage() {
    if (isValidImageUrl(_imageUrlController.text)) {
      setState(() {});
    }
  }

  //checagem da url
  bool isValidImageUrl(String url) {
    final String processedUrl = url.trim();
    bool startWithHttp = processedUrl.startsWith('http://');
    bool startWithHttps = processedUrl.startsWith('https://');
    bool endsWithPng = processedUrl.endsWith('.png');
    bool endsWithJpg = processedUrl.endsWith('.jpg');
    bool endsWithJpeg = processedUrl.endsWith('.jpeg');

    return (startWithHttp || startWithHttps) &&
        (endsWithPng || endsWithJpg || endsWithJpeg);
  }

  void _saveForm() {
    //checa se o formulario é válido
    bool isValid = _form.currentState!.validate();

    //se nao estriver válido n salva.
    if (!isValid) {
      return;
    }

    _form.currentState!.save();
    final newProduct = Product(
      id: Random().nextDouble().toString(),
      title: _formData['title'] as String,
      description: _formData['description'] as String,
      price: _formData['price'] as double,
      imageUrl: _formData['imageUrl'] as String,
    );

    Provider.of<ProductsList>(context).addProduct(newProduct);
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
      action: [
        IconButton(onPressed: _saveForm, icon: Icon(Icons.save)),
      ],
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              //Titulo
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Titulo',
                  errorText: titleError,
                ),
                //altera o botão do teclado do usuário para Next ao inves do subimit
                textInputAction: TextInputAction.next,
                //quando o usuário clica no subimit o foco do formulário muda para o campo preço
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                //valida o texto enquanto o usuário digita
                onChanged: (value) {
                  setState(() {
                    if (value.trim().isEmpty || value.trim().length <= 3) {
                      titleError = 'informe um título válido!';
                    } else {
                      titleError = null;
                    }
                  });
                },
                //validação de dados quando aperta salvar
                validator: (value) {
                  if (value!.trim().isEmpty || value.trim().length <= 3) {
                    return 'Informe um título válido!';
                  } else {
                    return null;
                  }
                },
                //quando houver o save começa a montar o map do objeto
                onSaved: (value) => _formData['title'] = value!,
              ),

              // -------  Preço  -------
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Preço',
                  prefixText: 'R\$ ',
                  errorText: priceError,
                ),
                textInputAction: TextInputAction.next,
                //indicação do foco
                focusNode: _priceFocusNode,
                //teclado numérico
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                //limita casas decimais e outros caracteres
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$')),
                ],
                //muda o foco para o campo descrição
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descritionFocusNode);
                },
                onChanged: (value) {
                  setState(() {
                    if (value.trim().isEmpty || double.parse(value) <= 0) {
                      priceError = 'informe um valor válido!';
                    } else {
                      priceError = null;
                    }
                  });
                },
                validator: (value) {
                  if (value!.trim().isEmpty || double.parse(value) <= 0) {
                    return 'Informe um valor válido!';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) => _formData['price'] = double.parse(value!),
              ),

              // ---------  Descrição -----------
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Descrição', errorText: descriptionError),
                //maximo de linhas
                maxLines: 3,
                //teclado adaptado para o usuário poder pular de linha, remoção do textInputAction
                keyboardType: TextInputType.multiline,
                focusNode: _descritionFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_imageUrlFocusNode);
                },
                onChanged: (value) {
                  setState(() {
                    if (value.trim().isEmpty || value.trim().length <= 5) {
                      descriptionError = 'informe um título válido!';
                    } else {
                      descriptionError = null;
                    }
                  });
                },
                validator: (value) {
                  if (value!.trim().isEmpty || value.trim().length <= 5) {
                    return 'Informe uma descrição válida!';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) => _formData['description'] = value!,
              ),

              // ------------  Imagem -------------
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
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      validator: (value) {
                        bool emptyUrl = value!.trim().isEmpty;
                        bool invalidUrl = !isValidImageUrl(value);
                        if (emptyUrl) {
                          return 'Informe uma URL válida';
                        }
                        if (invalidUrl) {
                          return 'São aceitas apenas terminações .png .jpg e .jpeg';
                        }
                        return null;
                      },
                      onSaved: (value) => _formData['imageUrl'] = value!,
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(top: 8, left: 10, right: 8),
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
              Container(
                margin: EdgeInsets.only(top: 30),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: FloatingActionButton(
                  elevation: 10,
                  onPressed: _saveForm,
                  child: Text(
                    'Salvar',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
