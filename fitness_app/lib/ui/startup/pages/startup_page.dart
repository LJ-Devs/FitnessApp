import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/startup_view_model.dart';
import '../../../routes/app_routes.dart';
import '../../../domain/auth/auth_provider.dart';
import 'package:flutter/scheduler.dart';

class StartupPage extends StatefulWidget {
  const StartupPage({super.key});
  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  
  @override
  void initState() {
    super.initState();
    // init before build
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      context.read<StartupViewModel>().init(authProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final status = context.watch<StartupViewModel>().status;

    switch (status) {
      case AuthStatus.loading:
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      case AuthStatus.loggedIn:
        return AppRoutes.routes[AppRoutes.home]!(context);
      case AuthStatus.loggedOut:
        return AppRoutes.routes[AppRoutes.login]!(context);
      case AuthStatus.error:
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Ocorreu um erro ao iniciar."),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                     // Try again
                     final authProvider = context.read<AuthProvider>();
                     context.read<StartupViewModel>().init(authProvider);
                  },
                  child: const Text("Tentar Novamente"),
                )
              ],
            ),
          ),
        );
    }
  }
}