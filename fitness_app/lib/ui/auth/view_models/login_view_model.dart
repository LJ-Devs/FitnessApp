import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/auth/auth_provider.dart';

class LoginViewModel extends ChangeNotifier {
  // Form state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  bool _rememberMe = false; 
  bool get rememberMe => _rememberMe;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Pw visibility
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  // Toggle remember
  void toggleRememberMe(bool value) {
    _rememberMe = value;
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

      // Local save remember state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('remember_me', _rememberMe);
      
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
      // Login errors
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email ou palavra-passe incorretos.';
      case 'user-disabled':
        return 'Este utilizador foi desativado.';
      case 'too-many-requests':
        return 'Demasiadas tentativas. Tenta mais tarde.';
      case 'invalid-email':
        return 'O email não é válido.';
        
      default:
        return 'Erro ao iniciar sessão. Tenta novamente: $code';
    }
  }
  
  // clean memory
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}