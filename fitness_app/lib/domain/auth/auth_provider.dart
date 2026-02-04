import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../entities/app_user.dart';
import '../../../data/services/firestore_service.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  final FirestoreService _firestoreService = FirestoreService();

  User? _user;
  User? get user => _user;
  bool get isAuthenticated => _user != null;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  // Login
  Future<void> signIn(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      _user = result.user;
      notifyListeners();
    } catch (e) {
      rethrow; 
    }
  }

  // Register with rollback
  Future<void> signUp(String email, String password, String name) async {
    try {
      // Auth
      final result = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );

      // Extra verification
      if (result.user == null) throw FirebaseAuthException(code: 'unknown', message: 'Erro ao criar utilizador');

      _user = result.user;

      try {
        // Save
        final newUser = AppUser(
          uid: _user!.uid,
          email: email,
          name: name,
        );

        await _firestoreService.saveUser(newUser);
        
        // Success
        notifyListeners();

      } catch (dbError) {
        // ROLLBACK: Delete user from auth
        await _user?.delete(); 
        _user = null;
        throw Exception("Falha ao salvar dados. Tente novamente.");
      }

    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}