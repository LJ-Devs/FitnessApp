import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/startup_view_model.dart';

import '../../home/pages/home_page.dart';
import '../../auth/pages/login_page.dart';

class StartupPage extends StatelessWidget {
  const StartupPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ouve o ViewModel
    final status = context.watch<StartupViewModel>().status;

    // Decide qual página mostrar
    switch (status) {
      case AuthStatus.loading:
        // Enquanto carrega (por trás do Splash Nativo),
        // mostramos um ecrã vazio ou loading simples.
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      
      case AuthStatus.loggedIn:
        return const HomePage();
      
      case AuthStatus.loggedOut:
        return const LoginPage();
    }
  }
}