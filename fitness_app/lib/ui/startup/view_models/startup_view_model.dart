import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

enum AuthStatus { loading, loggedIn, loggedOut }

class StartupViewModel extends ChangeNotifier {
  AuthStatus _status = AuthStatus.loading;

  AuthStatus get status => _status;

  StartupViewModel() {
    _checkStartup();
  }

  Future<void> _checkStartup() async {

    // Call UseCase from Auth
    await Future.delayed(const Duration(seconds: 2));

    bool hasToken = true; 
    _status = hasToken ? AuthStatus.loggedIn : AuthStatus.loggedOut;
    
    // Notify UI to swap screen
    notifyListeners();

    // Remove Native Splash
    FlutterNativeSplash.remove();
  }
}