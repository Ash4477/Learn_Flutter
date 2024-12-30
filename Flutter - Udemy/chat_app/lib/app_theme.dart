// lib/config/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // Theme Colors
  static const _primaryColor = Color(0xFFE91E63); // Pink
  static const _secondaryColor = Color(0xFF673AB7); // Deep Purple

  // Light Theme Color Scheme
  static final lightColorScheme = ColorScheme.light(
    primary: _primaryColor,
    secondary: _secondaryColor, // replaces accentColor
    error: const Color(0xFFB00020),
    onPrimary: Colors.white,
    onSecondary: Colors.white, // replaces accentColorBrightness
    onError: Colors.white,
    background: Colors.grey[50]!,
    onBackground: Colors.black,
    surface: Colors.white,
    onSurface: Colors.black,
  );

  // Dark Theme Color Scheme
  static final darkColorScheme = ColorScheme.dark(
    primary: _primaryColor,
    secondary: _secondaryColor,
    error: const Color(0xFFB00020),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onError: Colors.white,
    background: const Color(0xFF121212),
    onBackground: Colors.white,
    surface: const Color(0xFF1E1E1E),
    onSurface: Colors.white,
  );

  // Text Themes
  static final _baseTextTheme = TextTheme(
    displayLarge: const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: const TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: const TextStyle(fontSize: 16),
    bodyMedium: const TextStyle(fontSize: 14),
    labelLarge: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
  );

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    primaryColor: _primaryColor,
    primarySwatch: Colors.pink,
    textTheme: _baseTextTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: lightColorScheme.primary,
      foregroundColor: lightColorScheme.onPrimary,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20), // Updated to match your radius
        ),
      ),
    ),
    // Adding traditional buttonTheme for backward compatibility
    buttonTheme: ButtonThemeData(
      buttonColor: _primaryColor,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: Colors.grey[100],
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    primaryColor: _primaryColor,
    primarySwatch: Colors.pink,
    textTheme: _baseTextTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: darkColorScheme.primary,
      foregroundColor: darkColorScheme.onPrimary,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: _primaryColor,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: const Color(0xFF2C2C2C),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
