import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import '../../../domain/auth/auth_provider.dart';

enum AuthStatus { loading, loggedIn, loggedOut, error }

class StartupViewModel extends ChangeNotifier {
  AuthStatus _status = AuthStatus.loading;

  AuthStatus get status => _status;

  StartupViewModel();

  Future<void> init(AuthProvider authProvider) async {
    try {
      FlutterNativeSplash.remove();
      // Simulate a small delay
      await Future.delayed(const Duration(seconds: 1));

      // Verify current user
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Update provider with current user
        authProvider.setUser(currentUser); 
        _status = AuthStatus.loggedIn;
      } else {
        _status = AuthStatus.loggedOut;
      }

    } catch (e) {
      debugPrint("Startup initialization error: $e");
      _status = AuthStatus.error;
    } finally {
      notifyListeners();
    }
  }
}