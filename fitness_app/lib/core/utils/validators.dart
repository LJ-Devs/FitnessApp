class Validators {
  // Email regex
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  // Password regex min 8 char, 1UpperCase, 1 LowerCase, 1 Number e 1 Symbol
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[\W_]).{8,}$',
  );

  // URL simple regex
  static final RegExp _urlRegExp = RegExp(
    r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
  );

  // Email Validator
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'O email é obrigatório';
    }
    if (!_emailRegExp.hasMatch(value)) {
      return 'Introduza um email válido';
    }
    return null;
  }

  // Password validator
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'A password é obrigatória';
    }
    if (value.length < 8) {
      return 'A password deve ter pelo menos 8 caracteres';
    }
    if (!_passwordRegExp.hasMatch(value)) {
      return 'Mínimo: 1 maiúscula, 1 minúscula, 1 número e 1 símbolo';
    }
    return null;
  }

  static String? validateUrl(String? value) {
    // If optional and empty return null
    if (value == null || value.isEmpty) {
      return null; 
    }
    if (!_urlRegExp.hasMatch(value)) {
      return 'Insere um link válido (Ex: https://website.com/...)';
    }
    return null;
  }
}