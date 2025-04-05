// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/firebase_config.dart';
import '../exceptions/firebase_exceptions.dart';

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
      final responseData = jsonDecode(response.body);
      final String? errorMessage = responseData['error']['message'];
      final errorCode = errorMessage?.split(' : ').first;
      if (errorCode != null) {
        throw FirebaseExceptions(errorCode);
      }

      throw const FirebaseExceptions('Undifined');
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
      final String? errorMessage = responseData['error']['message'];
      final errorCode = errorMessage?.split(' : ').first;
      if (errorCode != null) {
        throw FirebaseExceptions(errorCode);
      }

      throw const FirebaseExceptions('Undifined');
    }

    return Future.value();
  }
}
