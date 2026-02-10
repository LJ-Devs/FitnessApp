import 'package:flutter/material.dart';
import 'tenant.dart';

final ThemeData lightMode = ThemeData(
  useMaterial3: true,
  fontFamily: tenant.fontFamily,

  scaffoldBackgroundColor: Colors.grey[50], // or Color(0xFFF9FAFB)

  // Base scheme by tenant
  colorScheme: ColorScheme.fromSeed(
    seedColor: tenant.mainColor,
    brightness: Brightness.light,
    primary: tenant.mainColor,
    // Secondary color
    secondary: tenant.mainColor.withValues(alpha: 0.7), 
    // Error color
    error: const Color(0xFFBA1A1A),
  ),

  // APP BAR
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent, // Transparent
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: tenant.mainColor), // Back "<"
    titleTextStyle: TextStyle(
      color: Colors.black87, 
      fontFamily: tenant.fontFamily,
      fontSize: 20,
      fontWeight: FontWeight.bold
    ),
  ),

  // Global Text
  textTheme: TextTheme(
    headlineLarge: const TextStyle(
      fontSize: 32, 
      fontWeight: FontWeight.bold, 
      color: Colors.black87
    ),
    headlineMedium: TextStyle(
      fontSize: 24, 
      fontWeight: FontWeight.bold, 
      color: tenant.mainColor
    ),
    bodyMedium: TextStyle(
      fontSize: 16, 
      color: Colors.grey.shade800 // Text color inside input
    ),
  ),

  // Input and text fields
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    
    // Empty label color
    labelStyle: TextStyle(color: Colors.grey.shade500),
    // Label focus color
    floatingLabelStyle: TextStyle(color: tenant.mainColor, fontWeight: FontWeight.bold),

    // Normal border
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    // Border Focus -> brand color
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: tenant.mainColor, width: 2),
    ),
    // Error borders
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 2),
    ),
    
    prefixIconColor: Colors.grey.shade500,
    suffixIconColor: Colors.grey.shade500,
  ),

  // Button style
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: tenant.mainColor,
      foregroundColor: Colors.white,
      disabledBackgroundColor: Colors.grey.shade300,
      disabledForegroundColor: Colors.grey.shade500,
      elevation: 2,
      shadowColor: tenant.mainColor.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: TextStyle(
        fontFamily: tenant.fontFamily,
        fontSize: 16, 
        fontWeight: FontWeight.bold
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    ),
  ),
);