import 'package:flutter/material.dart';

class AppTheme {
  // Updated theme colors for User App
  static const Color primaryYellow = Color(0xFF2196F3); // Blue (was Amber/Yellow)
  static const Color darkYellow = Color(0xFF03A9F4); // Light Blue (was Dark Yellow)
  static const Color lightYellow = Color(0xFF283593); // Dark Indigo (was Light Yellow)
  static const Color softYellow = Color(0xFFE3F2FD); // Soft Blue Background (was Soft Yellow)
  static const Color paleYellow = Color(0xFFF5F9FF); // Very Light Blue (was Very Light Yellow)
  static const Color white = Color(0xFFFFFFFF);
  static const Color darkGrey = Color(0xFF424242);
  static const Color mediumGrey = Color(0xFF757575);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color yellowGrey = Color(0xFFF0F7FF); // Light Blue Grey (was Light Yellow Grey)
  
  // Status colors
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color warningAmber = Color(0xFFFFB300);
  static const Color errorRed = Color(0xFFF44336);
  static const Color infoBlue = Color(0xFF2196F3);

  static ThemeData get userAppTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: primaryYellow, // Blue
      scaffoldBackgroundColor: paleYellow, // Very Light Blue
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryYellow, // Blue AppBar
        foregroundColor: white, // White text on blue
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: white), // White icons
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryYellow, // Blue buttons
          foregroundColor: white, // White text
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          elevation: 2,
        ),
      ),
      cardTheme: CardThemeData(
        color: white,
        elevation: 2,
        shadowColor: lightYellow.withOpacity(0.3), // Dark Indigo shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lightYellow), // Dark Indigo border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lightYellow), // Dark Indigo border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryYellow, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: white,
        selectedItemColor: darkYellow, // Light Blue for selected items
        unselectedItemColor: mediumGrey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: lightYellow.withOpacity(0.3), // Dark Indigo with opacity
        labelStyle: const TextStyle(color: darkYellow), // Light Blue text
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryYellow, // Blue FAB
        foregroundColor: white, // White icon
        elevation: 4,
      ),
    );
  }
}