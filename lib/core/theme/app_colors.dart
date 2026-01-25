import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary Palette
  static const Color primary = Color(0xFF6C3CD1); // Deep Purple
  static const Color primaryDark = Color(0xFF4A2A9A);
  static const Color primaryLight = Color(0xFFB18AFF);

  // Secondary/Accent
  static const Color accent = Color(
    0xFFFFC107,
  ); // Amber/Gold for Quranic accents
  static const Color accentSoft = Color(0xFFFFF3CD);

  // Backgrounds
  static const Color surfaceLight = Color(0xFFF9F9FC);
  static const Color backgroundLight = Color(0xFFFFFFFF);

  static const Color surfaceDark = Color(0xFF1E1E2C);
  static const Color backgroundDark = Color(0xFF12121F);

  // Text
  static const Color textPrimaryLight = Color(0xFF1D1B20);
  static const Color textSecondaryLight = Color(0xFF757575);

  static const Color textPrimaryDark = Color(0xFFE6E1E5);
  static const Color textSecondaryDark = Color(0xFFCAC4D0);

  // Functional
  static const Color error = Color(0xFFB3261E);
  static const Color success = Color(0xFF2E7D32);
}
