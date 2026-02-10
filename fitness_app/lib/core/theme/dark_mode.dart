import 'package:flutter/material.dart';
import 'tenant.dart';

final ThemeData darkMode = ThemeData(
  useMaterial3: true,
  fontFamily: tenant.fontFamily,

  // Base scheme by tenant
  colorScheme: ColorScheme.fromSeed(
    seedColor: tenant.mainColor,
    brightness: Brightness.dark,
    primary: tenant.mainColor,
    // Lighter secondary for visibility on dark bg
    secondary: tenant.mainColor.withValues(alpha: 0.8), 
    // Pastel red for errors
    error: const Color(0xFFCF6679), 
  ),

  scaffoldBackgroundColor: const Color(0xFF121212),

  // AppBar
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: Colors.white),
  ),

  // Global Text Styles
  textTheme: TextTheme(
    headlineLarge: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
    headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: tenant.mainColor),
    bodyMedium: TextStyle(fontSize: 16, color: Colors.grey.shade300),
  ),

  // Input and text fields
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF2C2C2C),
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),

    // Labels
    labelStyle: TextStyle(color: Colors.grey.shade400),
    floatingLabelStyle: TextStyle(color: tenant.mainColor, fontWeight: FontWeight.bold),
    hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),

    // Borders
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: tenant.mainColor, width: 2),
    ),
    
    // Error Borders
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFCF6679), width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFCF6679), width: 2),
    ),

    prefixIconColor: Colors.grey.shade400,
    suffixIconColor: Colors.grey.shade400,
  ),
  
  // Button style
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: tenant.mainColor,
      foregroundColor: Colors.white,
      // Disabled state colors
      disabledBackgroundColor: Colors.grey.shade800,
      disabledForegroundColor: Colors.grey.shade600,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    ),
  ),
);