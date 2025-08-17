import 'package:flutter/material.dart';

class AppTheme {
  // WhatsApp Colors
  static const Color primaryGreen = Color(0xFF25D366);
  static const Color secondaryGreen = Color(0xFF128C7E);
  static const Color lightGreen = Color(0xFFDCF8C6);
  static const Color darkGreen = Color(0xFF075E54);
  static const Color chatBubbleGreen = Color(0xFFDCF8C6);
  static const Color chatBubbleGrey = Color(0xFFF0F0F0);
  static const Color darkChatBubbleGrey = Color(0xFF262D31);
  static const Color darkChatBubbleBlue = Color(0xFF056162);

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryGreen,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 1,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryGreen,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE0E0E0),
        thickness: 0.5,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
        bodySmall: TextStyle(fontSize: 12, color: Colors.grey),
      ),
      colorScheme: ColorScheme.light(
        primary: primaryGreen,
        secondary: secondaryGreen,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black87,
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryGreen,
      scaffoldBackgroundColor: const Color(0xFF121B22),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF202C33),
        foregroundColor: Colors.white,
        elevation: 1,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF202C33),
        selectedItemColor: primaryGreen,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      cardTheme: const CardThemeData(
        color: Color(0xFF202C33),
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF374045),
        thickness: 0.5,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.white),
        bodySmall: TextStyle(fontSize: 12, color: Colors.grey),
      ),
      colorScheme: ColorScheme.dark(
        primary: primaryGreen,
        secondary: secondaryGreen,
        surface: const Color(0xFF202C33),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
      ),
    );
  }
}
