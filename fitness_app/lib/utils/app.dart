import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Routes
import '../routes/app_routes.dart';
//Themes
import '../ui/core/themes/tenant.dart';
import '../ui/core/themes/light_mode.dart';
import '../ui/core/themes/dark_mode.dart';
import '../ui/core/themes/theme_provider.dart';
// Auth
import '../domain/auth/auth_provider.dart';
import 'package:fitness_app/ui/auth/pages/auth_gate.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Theme provider
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        // Authentication Provider
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard on tap outside
            child: MaterialApp(
              title: tenant.name,
              debugShowCheckedModeBanner: false,
            
              // Visual config
              theme: lightMode,
              darkTheme: darkMode,
              themeMode: themeProvider.themeMode,
            
              // Routes configuration
              routes: AppRoutes.routes,
            
              // Start app
              home: const AuthGate(),
            ),
          );
        },
      ),
    );
  }
}