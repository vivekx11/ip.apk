import 'package:flutter/material.dart';

class AppTheme {
  // Indigo theme colors for Shop Owner App
  static const Color primaryIndigo = Color(0xFF3F51B5);
  static const Color lightIndigo = Color(0xFF9FA8DA);
  static const Color darkIndigo = Color(0xFF303F9F);
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color softBlue = Color(0xFFE3F2FD);
  static const Color blueGrey = Color(0xFF607D8B);
  static const Color white = Color(0xFFFFFFFF);
  static const Color darkGrey = Color(0xFF424242);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color errorRed = Color(0xFFF44336);

  static ThemeData get shopOwnerAppTheme {
    return ThemeData(
      primarySwatch: Colors.indigo,
      primaryColor: primaryIndigo,
      scaffoldBackgroundColor: white,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryIndigo,
        foregroundColor: white,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryIndigo,
          foregroundColor: white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      cardTheme: CardThemeData(
        color: white,
        elevation: 2,
        shadowColor: blueGrey.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryIndigo, width: 2),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: white,
        selectedItemColor: primaryIndigo,
        unselectedItemColor: blueGrey,
        type: BottomNavigationBarType.fixed,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: lightIndigo.withOpacity(0.2),
        labelStyle: const TextStyle(color: primaryIndigo),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}