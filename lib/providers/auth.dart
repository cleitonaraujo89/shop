import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/firebase_config.dart';
import '../exceptions/firebase_exceptions.dart';
import '../data/store.dart';

class Auth with ChangeNotifier {
  static const _urlNewUser = FirebaseConfig.urlNewUsers;
  static const _urlLogin = FirebaseConfig.urlLogin;
  String? _userId;
  String? _token;
  DateTime? _expiryDate;
  Timer? _logoutTimer;
  bool _expiredToken = false;

  //chama o get token e retorna true ou false
  bool get isAuth {
    return token != null;
  }

  bool get expiredToken => _expiredToken;

  String? get userId {
    return isAuth ? _userId : null;
  }

  //verifica se há token, data de expiração e se a data retornada esta depois do momento que é checado
  String? get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now())) {
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

    //envia os dados e aguarda a resposta
    final response = await http.post(
      Uri.parse(_urlLogin),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    //se tiver algum erro separa a msg retornada pelo firebase e lança
    //a exception personalizada
    if (response.statusCode >= 400) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String? errorMessage = responseData['error']['message'];
      final errorCode = errorMessage?.split(' : ').first;
      if (errorCode != null) {
        throw FirebaseExceptions(errorCode);
      }
      throw const FirebaseExceptions('Undifined');
    }

    //sem erros, começamos a trabalhar com os dados recebidos
    final responseBody = jsonDecode(response.body);

    //atribui o id, token e a validade do token
    _token = responseBody['idToken'];
    _userId = responseBody['localId'];

    //Pega a data de agora e adiciona o tempo de expiração
    //(obs. metodo utilizado apenas para mostrar o uso dode algumas funções do Date.time)
    _expiryDate = DateTime.now().add(
      Duration(
        seconds: int.parse(responseBody['expiresIn']),
      ),
    );

    //salva localmente (aparelho do usuario) as informaçoes
    Store.saveMap('userData', {
      'token': _token,
      'userId': _userId,
      'expiryDate': _expiryDate!.toIso8601String(),
      
    });

    //começa a contar o tempo de validade do token
    autoLogout();

    notifyListeners();
    return Future.value();
  }

  //  ----------- AUTO-LOGIN ------------
  // essa função evita q o usuário tenha que fazer varios logins
  // se o token ainda estiver válido ele vai entrar direto no app
  Future<void> tryAutoLogin() async{
    //se já tiver logado, retorna
    if (isAuth) {
      return Future.value();
    }

    //pega os dados locais
    final userData = await Store.getMap('userData');
    //checa se há dados
    if (userData == null) return Future.value();
    
    final expiryDate = DateTime.parse(userData['expiryDate']);
    //se a data de expiração do token for antes... retorna
    if (expiryDate.isBefore(DateTime.now())) {
      return Future.value();
    }

    _token = userData['token'];
    _userId = userData['userId'];
    _expiryDate = expiryDate;

    autoLogout();
    notifyListeners();
    return Future.value();
  }

  // ------------ LOGOUT --------------
  void logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;

    if (_logoutTimer != null) {
      _logoutTimer!.cancel();
      _logoutTimer = null;
    }

    Store.remove('userData');
    notifyListeners();
  }

  // ------------ AUTO LOGOUT --------------
  void expired() {
    _expiredToken = !_expiredToken;

    if (_token != null) {
      logout();
    }
  }

  void autoLogout() {
    //se existir um timer ele cancela e abre um novo
    if (_logoutTimer != null) {
      _logoutTimer!.cancel();
    }

    //pega a diferença em segundos
    // (obs. metodo utilizado apenas para mostrar o uso dode algumas funções do Date.time)
    final timeToLogout = _expiryDate!.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(Duration(seconds: timeToLogout), expired);
  }
}
