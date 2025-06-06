import 'dart:math';

import 'package:flutter/material.dart';
import '../components/auth_card.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 0.5),
                  Color.fromRGBO(255, 188, 117, 0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding:
                          const EdgeInsets.symmetric(vertical: 8, horizontal: 80),
                      //deixa o conteiner um pouco na vertical, utiliza o operador de cascata (..)
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.deepOrange.shade900,
                          boxShadow: const [
                            BoxShadow(
                                blurRadius: 8,
                                color: Colors.black26,
                                offset: Offset(0, 4))
                          ]),
                      child: Text(
                        'Minha Loja',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 45,
                            fontFamily: 'Anton'),
                      ),
                    ),
                    const AnimatedSize(
                      duration: Duration(milliseconds: 500),
                      child: AuthCard(),
                    ),
                    //AuthCard(), // modo de animação antigo
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
