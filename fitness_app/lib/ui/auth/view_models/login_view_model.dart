import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import '../../../domain/auth/auth_provider.dart';

class LoginViewModel extends ChangeNotifier {
  // Form state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  // Pw visibility
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  // ======================= LOGIN =======================

  Future<bool> login(AuthProvider authProvider) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await authProvider.signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
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

  // ======================= REGISTER =======================

  Future<bool> register(AuthProvider authProvider) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      // Basic validation
      if (nameController.text.trim().isEmpty) {
        throw FirebaseAuthException(code: 'invalid-name', message: 'Name is required');
      }

      await authProvider.signUp(
        emailController.text.trim(),
        passwordController.text.trim(),
        nameController.text.trim(),
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

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Errors
  String _mapFirebaseError(String code) {
    switch (code) {
      // Login errors
      case 'user-not-found':
        return 'Utilizador não encontrado.';
      case 'wrong-password':
        return 'Password incorreta.';
      case 'user-disabled':
        return 'Este utilizador foi desativado.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente mais tarde.';
      
      // Register errors (Added these)
      case 'email-already-in-use':
        return 'Este email já está registado.';
      case 'invalid-email':
        return 'O email não é válido.';
      case 'weak-password':
        return 'A password é muito fraca.';
      case 'invalid-name':
        return 'Por favor, insira um nome válido.';
        
      default:
        return 'Erro de autenticação: $code';
    }
  }
  
  // clean memory
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose(); // Added this to prevent memory leaks
    super.dispose();
  }
}