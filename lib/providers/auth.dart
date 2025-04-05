// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/firebase_config.dart';
import '../exceptions/firebase_exceptions.dart';

class Auth with ChangeNotifier {
  static const _urlNewUser = FirebaseConfig.urlNewUsers;
  static const _urlLogin = FirebaseConfig.urlLogin;
  String? _token;
  DateTime? _expiryDate;

  //chama o get token e retorna true ou false
  bool get isAuth {
    return token != null;
  }

  //verifica se há token, data de expiração e se a data retornada esta depois do momento que é checado
  String? get token {
    if (_token != null && _expiryDate != null && _expiryDate!.isAfter(DateTime.now())) {
      return _token!;
    } else {
      return null;
    }
  }

  //  --------------------- CADASTRO -----------------------------
  Future<String?> signup(String email, String password) async {
    final response = await http.post(
      Uri.parse(_urlNewUser),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    //passa somente a primeira parte da msg de erro
    if (response.statusCode >= 400) {
      final responseData = jsonDecode(response.body);
      final String? errorMessage = responseData['error']['message'];
      final errorCode = errorMessage?.split(' : ').first;
      if (errorCode != null) {
        throw FirebaseExceptions(errorCode);
      }

      throw const FirebaseExceptions('Undefined');
    }
    return Future.value();
  }

  // ------------ LOGIN --------------
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
      final String? errorMessage = responseData['error']['message'];
      final errorCode = errorMessage?.split(' : ').first;
      if (errorCode != null) {
        throw FirebaseExceptions(errorCode);
      }
      throw const FirebaseExceptions('Undifined');
    }

    final responseBody = jsonDecode(response.body);

    _token = responseBody['idToken'];

    //Pega a data de agora e adiciona o tempo de expiração
    _expiryDate = DateTime.now().add(
      Duration(
        seconds: int.parse(responseBody['expiresIn']),
      ),
    );

    return Future.value();
  }
}
