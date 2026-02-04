import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Routes
import '../routes/app_routes.dart';
//Themes
import '../ui/core/themes/tenant.dart';
import '../ui/core/themes/light_mode.dart';
import '../ui/core/themes/dark_mode.dart';
import '../ui/core/themes/theme_provider.dart';
// Startup
import '../ui/startup/view_models/startup_view_model.dart';
import '../ui/startup/pages/startup_page.dart';
// Auth
import '../domain/auth/auth_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Theme provider
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        // Startup Provider
        ChangeNotifierProvider(create: (_) => StartupViewModel()),
        // Authentication Provider
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: tenant.name,
            debugShowCheckedModeBanner: false,

            // Visual config
            theme: lightMode,
            darkTheme: darkMode,
            themeMode: themeProvider.themeMode,

            // Routes configuration
            routes: AppRoutes.routes,

            // Start app
            home: const StartupPage(),
          );
        },
      ),
    );
  }
}