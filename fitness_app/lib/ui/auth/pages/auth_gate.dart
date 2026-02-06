import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import '../../../routes/app_routes.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // Stream listtens to auth state changes (login/logout)
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        
        // Loading state while checking auth status
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Remove splash screen once we have auth state
        FlutterNativeSplash.remove();

        // If user is logged in, go to Home, otherwise go to Login
        if (snapshot.hasData) {
          return AppRoutes.routes[AppRoutes.home]!(context);
        } 
        
        // If no user, show login page
        else {
          return AppRoutes.routes[AppRoutes.login]!(context);
        }
      },
    );
  }
}