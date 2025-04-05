import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/firebase_config.dart';

class Auth with ChangeNotifier {
  static const _urlNewUser = FirebaseConfig.urlNewUsers;
  static const _urlLogin = FirebaseConfig.urlLogin;

  Future<String?> signup(String email, String password) async {
    final response = await http.post(
      Uri.parse(_urlNewUser),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    if (response.statusCode >= 400) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String errorMensage = responseData['error']['message'];

      if (errorMensage.startsWith('INVALID')) {
        throw Exception('Email Inválido');
      }

      if (errorMensage.startsWith('EMAIL')) {
        throw Exception('Email Já Cadastrado');
      }

      if (errorMensage.startsWith('TOO')) {
        throw Exception('Numero de tentativas exedidas, tente mais tarde.');
      }

      throw Exception('Erro ao enviar os dados');
    }

    return Future.value();
  }

  Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(_urlLogin),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    if (response.statusCode >= 400) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String errorMensage = responseData['error']['message'];

      if (errorMensage.startsWith('INVALID')) {
        throw Exception('Senha incorreta');
      }

      if (errorMensage.startsWith('EMAIL')) {
        throw Exception('Email não cadastrado');
      }

      if (errorMensage.startsWith('TOO')) {
        throw Exception('Numero de tentativas exedidas, tente mais tarde.');
      }

      if (errorMensage.startsWith('USER')) {
        throw Exception('Usuário Desativado!');
      }

      throw Exception('Erro ao enviar os dados');
    }

    return Future.value();
  }
}
