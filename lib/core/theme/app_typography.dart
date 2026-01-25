import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class AppTypography {
  static const String fontFamilyUI = 'Cairo';
  static const String fontFamilyQuran = 'Amiri';

  static TextTheme getTextTheme(bool isDark) {
    Color primaryColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    Color secondaryColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return TextTheme(
      // Headlines
      headlineLarge: TextStyle(
        fontFamily: fontFamilyUI,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: primaryColor,
      ),
      headlineMedium: TextStyle(
        fontFamily: fontFamilyUI,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      headlineSmall: TextStyle(
        fontFamily: fontFamilyUI,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),

      // Titles
      titleLarge: TextStyle(
        fontFamily: fontFamilyUI,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      titleMedium: TextStyle(
        fontFamily: fontFamilyUI,
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: primaryColor,
      ),
      titleSmall: TextStyle(
        fontFamily: fontFamilyUI,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: primaryColor,
      ),

      // Body
      bodyLarge: TextStyle(
        fontFamily: fontFamilyUI,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: primaryColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontFamilyUI,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: secondaryColor,
      ),
      bodySmall: TextStyle(
        fontFamily: fontFamilyUI,
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: secondaryColor,
      ),

      // Labels (Buttons, etc)
      labelLarge: TextStyle(
        fontFamily: fontFamilyUI,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
    );
  }

  // Specialized styles for Quran text
  static TextStyle quranText({double fontSize = 24, Color? color}) {
    return TextStyle(
      fontFamily: fontFamilyQuran,
      fontSize: fontSize,
      height: 2.0, // Comfortable line height for Arabic
      color: color ?? AppColors.textPrimaryLight,
    );
  }
}
