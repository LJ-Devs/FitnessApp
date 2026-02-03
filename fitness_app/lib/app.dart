import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//Themes
import 'ui/core/themes/tenant.dart';
import 'ui/core/themes/light_mode.dart';
import 'ui/core/themes/dark_mode.dart';
import 'ui/core/themes/theme_provider.dart';
// Startup
import 'ui/startup/view_models/startup_view_model.dart';
import 'ui/startup/pages/startup_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Global provider
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        // Startup Provider
        ChangeNotifierProvider(create: (_) => StartupViewModel()),
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

            // Start app
            home: const StartupPage(),
          );
        },
      ),
    );
  }
}