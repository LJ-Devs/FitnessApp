import 'package:flutter/material.dart';
import '../../domain/usecases/login_usecase.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginUseCase loginUseCase;

  // UseCase injection into the constructor
  LoginViewModel({required this.loginUseCase});

  // --- UI State ---
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  // Safety flag to prevent memory leaks and crashes
  bool _isDisposed = false;

  // --- Controllers ---
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  // Login logic.
  Future<bool> login() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Call the Domain Layer
    final result = await loginUseCase(LoginParams(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    ));

    // If the user left the screen during the request, stop here.
    if (_isDisposed) return false;

    bool isSuccess = false;

    // Handle the result
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        isSuccess = false;
      },
      (user) {
        _errorMessage = null;
        isSuccess = true;
      },
    );

    _isLoading = false;

    if (!_isDisposed) notifyListeners();

    return isSuccess;
  }

  @override
  void dispose() {
    _isDisposed = true;
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}