import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import '../../../routes/app_routes.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // O stream ouve o Firebase (Login, Logout, Token Expirado, App Aberta)
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        
        // 1. A CARREGAR (Estado Indeterminado)
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Já sabemos o estado, removemos o Splash Screen nativo
        FlutterNativeSplash.remove();

        // 2. TEM USER? (Logado) -> Entra na App (Dashboard)
        if (snapshot.hasData) {
          return AppRoutes.routes[AppRoutes.home]!(context);
        } 
        
        // 3. NÃO TEM USER? (Visitante) -> Vai para o Login
        else {
          return AppRoutes.routes[AppRoutes.login]!(context);
        }
      },
    );
  }
}