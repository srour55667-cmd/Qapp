import 'package:flutter/material.dart';

class AppThemes {
  static const Color primaryColor = Color(0xFF9543FF);

  // -----------------------------
  //  LIGHT THEME
  // -----------------------------
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF5EDFF),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF5EDFF),
      elevation: 0,
      centerTitle: true,
      foregroundColor: Colors.black,
    ),
    cardColor: Colors.white,
    cardTheme: CardThemeData(
      elevation: 1,
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    iconTheme: const IconThemeData(color: primaryColor, size: 26),
  );

  // -----------------------------
  //  DARK THEME
  // -----------------------------
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF0F0A1E),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0F0A1E),
      elevation: 0,
      centerTitle: true,
      foregroundColor: Colors.white,
    ),
    cardColor: const Color(0xFF1A132E),
    cardTheme: CardThemeData(
      elevation: 2,
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
    iconTheme: const IconThemeData(color: primaryColor),
  );

  // -----------------------------
  //  SEPIA THEME
  // -----------------------------
  static final ThemeData sepiaTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF3E8D3),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.brown,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF3E8D3),
      elevation: 0,
      centerTitle: true,
      foregroundColor: Colors.black,
    ),
    cardColor: const Color(0xFFFFF6E6),
    cardTheme: CardThemeData(
      elevation: 0,
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    iconTheme: const IconThemeData(color: Colors.brown),
  );
}
