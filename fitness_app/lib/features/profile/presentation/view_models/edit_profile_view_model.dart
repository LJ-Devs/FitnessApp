import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/usecases/update_profile_usecase.dart';

class EditProfileViewModel extends ChangeNotifier {
  // Dependency Injection
  final UpdateProfileUseCase updateProfileUseCase;

  EditProfileViewModel({required this.updateProfileUseCase}) {
    _loadCurrentData();
  }

  bool _isDisposed = false;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isPickingImage = false;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  // Input Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  // Load current user data into controllers
  void _loadCurrentData() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      nameController.text = user.displayName ?? "";
      emailController.text = user.email ?? "";
    }
  }

  Future<void> pickImage() async {
    if (_isPickingImage) return;
    _isPickingImage = true;

    try {
      final ImagePicker picker = ImagePicker();
      // Pick image from gallery
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
      if (image != null) {
        _selectedImage = File(image.path); // Store selected image as File
        notifyListeners(); // Notify UI to update
      }
    } 
    finally {
      _isPickingImage = false;
    }
  }

  Future<bool> saveChanges() async {
    _setLoading(true);
    _errorMessage = null;

    final newName = nameController.text.trim();

    // Basic validation
    if (newName.isEmpty) {
      _errorMessage = "O nome não pode estar vazio.";
      _setLoading(false);
      return false;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _errorMessage = "Sessão inválida.";
      _setLoading(false);
      return false;
    }

    // Call Domain Layer
    final result = await updateProfileUseCase(UpdateProfileParams(
      uid: user.uid,
      name: newName,
      imageFile: _selectedImage,
    ));

    bool success = false;

    // Handle Result
    result.fold(
      (failure) {
        _errorMessage = "Erro ao guardar: ${failure.message}";
        success = false;
      },
      (_) {
        success = true;
      },
    );

    _setLoading(false);
    return success;
  }

  void _setLoading(bool value) {
    if (_isDisposed) return;
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}