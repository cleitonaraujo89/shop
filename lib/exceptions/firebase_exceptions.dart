class FirebaseExceptions implements Exception {
  static const Map<String, String> errors = {
    'EMAIL_EXISTS': '',
    'OPERATION_NOT_ALLOWED': '',
    'TOO_MANY_ATTEMPTS_TRY_LATER': '',
    'EMAIL_NOT_FOUND': '',
    'INVALID_PASSWORD': '',
    'USER_DISABLED': '',
    '': '',
  };
}