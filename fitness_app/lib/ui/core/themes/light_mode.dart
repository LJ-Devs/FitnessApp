import 'package:flutter/material.dart';
import 'tenant.dart';

final ThemeData lightMode = ThemeData(
  useMaterial3: true,
  fontFamily: tenant.fontFamily,

  // Base scheme by tenant
  colorScheme: ColorScheme.fromSeed(
    seedColor: tenant.mainColor,
    brightness: Brightness.light,
    primary: tenant.mainColor,
  ),

  scaffoldBackgroundColor: Colors.white,

  // Input and text fields
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.shade100,
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
    prefixIconColor: Colors.grey.shade500,
    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
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