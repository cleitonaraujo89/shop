// ignore_for_file: constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';
import '../utils/validator_forms.dart';

enum AuthMode { Signup, Login }

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  AuthMode _authMode = AuthMode.Login;
  final _passwordController = TextEditingController();
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  void _submit (){

  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: 320,
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16),
        child: Form(
            child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
              initialValue: '',
              validator: (value) =>
                  validadeForms(submitedText: value!, email: true),
              onSaved: (value) => _authData['email'] = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Senha'),
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
            if (_authMode == AuthMode.Signup)
              TextFormField(
                decoration: InputDecoration(labelText: 'Confirmação de Senha'),
                initialValue: '',
                obscureText: true,
                validator: _authMode == AuthMode.Signup
                    ? (value) => validadeForms(
                        submitedText: value!,
                        equalityCheck: _passwordController.text)
                    : null,
                onSaved: (newValue) => _authData['password'] = newValue!,
              ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 194, 77, 214),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10)),
              onPressed: _submit,
              child: Text(
                _authMode == AuthMode.Login ? 'ENTRAR' : 'REGISTRAR',
                style: TextStyle(fontSize: 16),
              ),
            )
          ],
        )),
      ),
    );
  }
}
