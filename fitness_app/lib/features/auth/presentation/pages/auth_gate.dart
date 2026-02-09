import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../home/presentation/pages/home_page.dart'; 
import 'login_page.dart'; 

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        
        // Loading while Firebase verification
        if (snapshot.connectionState == ConnectionState.waiting) {
             return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        // User is logged in
        if (snapshot.hasData) {
          return const HomePage();
        }
        // User is NOT logged in
        else {
          return const LoginPage();
        }
      },
    );
  }
}