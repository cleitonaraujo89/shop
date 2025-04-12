// ignore_for_file: constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shop/exceptions/firebase_exceptions.dart';
import '../components/alert.dart';
import '../utils/validator_forms.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

enum AuthMode { Signup, Login }

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _form = GlobalKey();
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.Login;
  final _passwordController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    //ativa um controler baseado em cada frame atualizado na tela pelo vsync
    // isso é possivel pois esta classe tem o SingleTickerProviderStateMixin
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _opacityAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  //fechamos os controlers quando o widget for descartado
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _passwordController.dispose();
  }

  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  String _textAdp = '';

  Future<void> _submit() async {
    //checa a validação e se for falsa retorna
    if (_form.currentState != null && !_form.currentState!.validate()) {
      return;
    }

    //muda o estado para exibir o loading
    setState(() {
      _isLoading = true;
    });

    //ativa todos os onSaved do Form
    _form.currentState!.save();

    final Auth auth = Provider.of<Auth>(context, listen: false);

    try {
      if (_authMode == AuthMode.Login) {
        await auth.login(
            _authData['email'] as String, _authData['password'] as String);
      } else {
        await auth.signup(
            _authData['email'] as String, _authData['password'] as String);
      }
    } on FirebaseExceptions catch (e) {
      alert(
        context: context,
        title: 'Oops!',
        content: e.toString(),
      );
    } catch (e) {
      alert(
        context: context,
        title: 'Oops!',
        content: 'Algo deu errado =/',
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_authMode == AuthMode.Login) {
      _textAdp = 'Não ';
    } else {
      _textAdp = 'Já ';
    }
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: deviceSize.width * 0.75,
        //height: _heightAnimation!.value.height, // método de animação antigo
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                initialValue: '',
                validator: (value) =>
                    validadeForms(submitedText: value!, email: true),
                onSaved: (value) => _authData['email'] = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Senha'),
                controller: _passwordController,
                obscureText: true,
                validator: (value) => validadeForms(
                  submitedText: value ?? '',
                  specialCaracteres: true,
                  uppercaseLetter: true,
                  lenght: 5,
                ),
                onSaved: (newValue) => _authData['password'] = newValue!,
              ),
              //if (_authMode == AuthMode.Signup) // nao precisa mais
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                //altera o tamanho do conteiner sob a condicional
                constraints: BoxConstraints(
                  minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                  maxHeight: _authMode == AuthMode.Signup ? 120 : 0,
                ),
                curve: Curves.linear,
                //altera a opacidade do elemnto
                child: FadeTransition(
                  opacity: _opacityAnimation,
                  child: TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Confirmação de Senha'),
                    initialValue: '',
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) => validadeForms(
                            submitedText: value!,
                            equalityCheck: _passwordController.text)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const CircularProgressIndicator.adaptive()
              else
                AnimatedSize(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 194, 77, 214),
                        foregroundColor: Colors.white,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 30, vertical: 10)),
                    onPressed: _submit,
                    child: Text(
                      _authMode == AuthMode.Login ? 'ENTRAR' : 'REGISTRAR',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Text('$_textAdp possui conta?  '),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          if (_authMode == AuthMode.Login) {
                            _authMode = AuthMode.Signup;
                            _controller.forward();
                          } else {
                            _authMode = AuthMode.Login;
                            _controller.reverse();
                          }
                        });
                      },
                      child: _authMode == AuthMode.Login
                          ? const Text('Cadastre-se')
                          : const Text('Fazer Login')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
