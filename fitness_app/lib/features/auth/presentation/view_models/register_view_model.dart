import 'package:flutter/material.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/usecases/register_usecase.dart';

class RegisterViewModel extends ChangeNotifier {
  // Dependency Injection
  final RegisterUseCase registerUseCase;

  RegisterViewModel({required this.registerUseCase});

  // --- UI State ---
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  // --- Controllers ---
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  // Registration logic
  Future<bool> register() async {
    _errorMessage = null;

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // --- UI Validation ---
    if (name.isEmpty) {
      _errorMessage = "O nome é obrigatório.";
      notifyListeners();
      return false;
    }

    final emailError = Validators.validateEmail(email);
    if (emailError != null) {
      _errorMessage = emailError;
      notifyListeners();
      return false;
    }

    final passwordError = Validators.validatePassword(password);
    if (passwordError != null) {
      _errorMessage = passwordError;
      notifyListeners();
      return false;
    }

    // Business Logic
    _isLoading = true;
    notifyListeners();

    final result = await registerUseCase(RegisterParams(
      email: email,
      password: password,
      name: name,
    ));

    bool isSuccess = false;

    // Handle result from Domain Layer
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        isSuccess = false;
      },
      (user) {
        isSuccess = true;
      },
    );

    _isLoading = false;
    notifyListeners();
    return isSuccess;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}