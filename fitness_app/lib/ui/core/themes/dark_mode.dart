import 'package:flutter/material.dart';
import 'tenant.dart';

final ThemeData darkMode = ThemeData(
  useMaterial3: true,
  fontFamily: tenant.fontFamily,

  // Base scheme by tenant
  colorScheme: ColorScheme.fromSeed(
    seedColor: tenant.mainColor,
    brightness: Brightness.dark,
  ),

  scaffoldBackgroundColor: const Color(0xFF121212),

  // AppBar
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF121212),
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
  ),

  // Input and text fields
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF2C2C2C),
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),

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
    prefixIconColor: Colors.grey.shade400,
    hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
  ),
  
  // Button style
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: tenant.mainColor,
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    ),
  ),
);