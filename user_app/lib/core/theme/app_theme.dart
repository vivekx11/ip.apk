import 'package:flutter/material.dart';

class AppTheme {
  // Pink theme colors for User App
  static const Color primaryPink = Color(0xFFE91E63);
  static const Color lightPink = Color(0xFFF8BBD9);
  static const Color softPink = Color(0xFFFCE4EC);
  static const Color white = Color(0xFFFFFFFF);
  static const Color darkGrey = Color(0xFF424242);
  static const Color lightGrey = Color(0xFFF5F5F5);

  static ThemeData get userAppTheme {
    return ThemeData(
      primarySwatch: Colors.pink,
      primaryColor: primaryPink,
      scaffoldBackgroundColor: white,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryPink,
        foregroundColor: white,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPink,
          foregroundColor: white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
      ),
      cardTheme: CardThemeData(
        color: white,
        elevation: 4,
        shadowColor: lightPink.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryPink, width: 2),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: white,
        selectedItemColor: primaryPink,
        unselectedItemColor: darkGrey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}