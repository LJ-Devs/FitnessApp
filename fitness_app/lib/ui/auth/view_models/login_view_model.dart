import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import '../../../domain/auth/auth_provider.dart';

class LoginViewModel extends ChangeNotifier {
  bool _isDisposed = false;

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

  // Pw visibility
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    if (!_isDisposed) notifyListeners();
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

  // ======================= HELPERS =======================

  void _setLoading(bool value) {
    // Safety check: stop if view is gone
    if (_isDisposed) return;
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
    _isDisposed = true; // Mark as disposed
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}