import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Routes
import 'routes/app_routes.dart';
//Themes
import 'core/theme/tenant.dart';
import 'core/theme/light_mode.dart';
import 'core/theme/dark_mode.dart';
import 'core/theme/theme_provider.dart';
// Auth
import 'package:fitness_app/features/auth/presentation/pages/auth_gate.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Theme provider
        ChangeNotifierProvider(create: (_) => ThemeProvider()),   
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