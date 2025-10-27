import 'package:flutter/material.dart';

class AppTheme {
  static const Color lightPrimary = Color.fromARGB(255, 33, 150, 243);
  static const Color lightSecondary = Color.fromARGB(255, 66, 165, 245);
  static const Color lightBackground = Color.fromARGB(255, 255, 255, 255);
  static const Color lightSurface = Color.fromARGB(255, 250, 250, 250);
  static const Color lightText = Color.fromARGB(255, 33, 33, 33);

  static const Color darkPrimary = Color.fromARGB(255, 25, 118, 210);
  static const Color darkSecondary = Color.fromARGB(255, 30, 136, 229);
  static const Color darkBackground = Color.fromARGB(255, 18, 18, 18);
  static const Color darkSurface = Color.fromARGB(255, 30, 30, 30);
  static const Color darkText = Color.fromARGB(255, 255, 255, 255);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: lightPrimary,
      scaffoldBackgroundColor: lightBackground,
      colorScheme: const ColorScheme.light(
        primary: lightPrimary,
        secondary: lightSecondary,
        surface: lightSurface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: lightPrimary,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: lightPrimary,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: lightPrimary, width: 2),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: darkPrimary,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: darkPrimary,
        secondary: darkSecondary,
        surface: darkSurface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkPrimary,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: darkPrimary,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: darkPrimary, width: 2),
        ),
      ),
    );
  }
}