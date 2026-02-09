import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Temporary, until there are UseCases

class DashboardViewModel extends ChangeNotifier {
  // 'GetUserProfileUseCase' injection here
  
  String _userName = 'Atleta';
  String get userName => _userName;

  DashboardViewModel() {
    _loadUserData();
  }

  void _loadUserData() {
    // Temporary
    final user = FirebaseAuth.instance.currentUser;
    if (user?.displayName != null && user!.displayName!.isNotEmpty) {
      _userName = user.displayName!;
      notifyListeners();
    }
    // Call UseCase to present complex data
  }
}