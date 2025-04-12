import 'package:flutter/material.dart';

class CustomRoute extends MaterialPageRoute {
  //construtor passando os parametros diretamente pro super
  CustomRoute({
    required super.builder,
    super.settings,
  });

  @override
  Widget buildTransitions(
    BuildContext context,
    // trabalha de 0.0 a 1.0
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (settings.name == '/') {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
