String? validadeForms(
    {required String submitedText,
    bool? email,
    bool? specialCaracteres,
    bool? uppercaseLetter,
    int? lenght,
    String? equalityCheck}) {
  final RegExp specialChars = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
  final RegExp uppercaseRegExp = RegExp(r'[A-Z]');

  if (submitedText.isEmpty) {
    return 'Campo vazio!';
  }

  if ((email ?? false) &&
      (!submitedText.contains('@') || !submitedText.contains('.'))) {
    return 'Email inválido';
  }

  if ((specialCaracteres ?? false) && !specialChars.hasMatch(submitedText)) {
    return 'Insira ao menos um caracter especial.';
  }

  if (lenght != null && submitedText.length < lenght) {
    return 'Insira no mínimo $lenght caracteres.';
  }

  if ((uppercaseLetter ?? false) && !uppercaseRegExp.hasMatch(submitedText)) {
    return 'Insira ao menos uma letra maiúscula.';
  }

  if (equalityCheck != null && submitedText != equalityCheck) {
    return 'A confirmação está errada!';
  }

  return null;
}
