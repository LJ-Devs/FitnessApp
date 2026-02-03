import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/core/themes/tenant.dart';
import 'ui/core/themes/light_mode.dart';
import 'ui/core/themes/dark_mode.dart';
import 'ui/core/themes/theme_provider.dart';
import 'ui/splash/pages/splash_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: tenant.name,
      debugShowCheckedModeBanner: false,

      // --- Theme Config ---
      theme: lightMode,     
      darkTheme: darkMode,  
      
      // Auto change by provider
      themeMode: themeProvider.themeMode, 

      home: const SplashPage(),
    );
  }
}