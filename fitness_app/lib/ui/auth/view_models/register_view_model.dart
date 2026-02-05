import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import '../../../domain/auth/auth_provider.dart';
import '../../../utils/validators.dart';

class RegisterViewModel extends ChangeNotifier {
  // Form state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  bool _rememberMe = true; 
  bool get rememberMe => _rememberMe;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Text controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Pw visibility
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  // ======================= REGISTER =======================

  Future<bool> register(AuthProvider authProvider) async {
    _setLoading(true);
    _errorMessage = null;

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      // Basic validation
      if (name.isEmpty) {
        _errorMessage = "O nome é obrigatório.";
        _setLoading(false);
        return false;
      }

      final emailError = Validators.validateEmail(email);
      if (emailError != null) {
        _errorMessage = emailError; // Error message from validator
        _setLoading(false);
        return false;
      }

      final passwordError = Validators.validatePassword(password);
      if (passwordError != null) {
        _errorMessage = passwordError; // Error message from validator
        _setLoading(false);
        return false;
      }

      await authProvider.signUp(
        email,
        password,
        name,
      );
      
      _setLoading(false);
      return true; // Success

    } on FirebaseAuthException catch (e) {
      _errorMessage = _mapFirebaseError(e.code);
      _setLoading(false);
      return false; // failed
    } catch (e) {
      _errorMessage = "Ocorreu um erro inesperado.";
      _setLoading(false);
      return false;
    }
  }

  // ======================= HELPERS =======================

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Errors
  String _mapFirebaseError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Este email já está registado.';
      case 'invalid-email':
        return 'O formato do email não é válido.';
      case 'weak-password':
        return 'A password é demasiado fraca.';
      case 'empty-fields':
        return 'Por favor, preencha todos os campos.';
        
      default:
        return 'Erro ao criar conta: $code';
    }
  }
  
  // clean memory
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}