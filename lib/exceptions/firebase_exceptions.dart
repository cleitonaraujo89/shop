class FirebaseExceptions implements Exception {
  const FirebaseExceptions(this.key);
  final String key;

  static const Map<String, String> errors = {
    'EMAIL_EXISTS': 'Email Já Cadastrado',
    'OPERATION_NOT_ALLOWED':
        'Operação nao permitida, entre em contato com o administrador',
    'TOO_MANY_ATTEMPTS_TRY_LATER':
        'Numero de tentativas exedidas, tente mais tarde.',
    'EMAIL_NOT_FOUND': 'Email não cadastrado',
    'INVALID_PASSWORD': 'Senha incorreta.',
    'INVALID_LOGIN_CREDENTIALS': 'Login ou senha incorreta',
    'USER_DISABLED': 'Usuário Desativado!',
    'INVALID_EMAIL': 'Email Inválido',
    'WEAK_PASSWORD': 'Senha deve ter no mínimo 6 caracteres'
  };

  @override
  String toString() {
    if (errors.containsKey(key)) {
      return errors[key] as String;
    } else {
      return 'Ocorreu um erro na autenticação';
    }
  }
}
