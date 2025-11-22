import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppTheme { system, light, dark, sepia }

enum AppFont { cairo, amiri, noto, scheherazade }

class ThemeState {
  final ThemeMode themeMode;
  final AppTheme appTheme;
  final AppFont appFont;
  final double fontScale;

  const ThemeState({
    required this.themeMode,
    required this.appTheme,
    required this.appFont,
    required this.fontScale,
  });

  ThemeState copyWith({
    ThemeMode? themeMode,
    AppTheme? appTheme,
    AppFont? appFont,
    double? fontScale,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      appTheme: appTheme ?? this.appTheme,
      appFont: appFont ?? this.appFont,
      fontScale: fontScale ?? this.fontScale,
    );
  }
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit()
    : super(
        const ThemeState(
          themeMode: ThemeMode.system,
          appTheme: AppTheme.system,
          appFont: AppFont.cairo,
          fontScale: 1.0,
        ),
      ) {
    _loadSettings();
  }

  // -------------------------
  // تحميل الإعدادات
  // -------------------------
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final themeIndex = prefs.getInt("theme") ?? 0;
    final fontIndex = prefs.getInt("font") ?? 0;
    final scale = prefs.getDouble("fontScale") ?? 1.0;

    final AppTheme theme = AppTheme.values[themeIndex];
    final AppFont font = AppFont.values[fontIndex];

    emit(
      state.copyWith(
        appTheme: theme,
        themeMode: _convertThemeMode(theme),
        appFont: font,
        fontScale: scale.clamp(0.8, 1.6),
      ),
    );
  }

  // تحويل AppTheme → ThemeMode
  ThemeMode _convertThemeMode(AppTheme theme) {
    switch (theme) {
      case AppTheme.light:
        return ThemeMode.light;
      case AppTheme.dark:
        return ThemeMode.dark;
      case AppTheme.sepia:
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  // -------------------------
  // تغيير الثيم
  // -------------------------
  void changeTheme(AppTheme theme) async {
    emit(state.copyWith(appTheme: theme, themeMode: _convertThemeMode(theme)));

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("theme", theme.index);
  }

  // -------------------------
  // تغيير الخط
  // -------------------------
  void changeFont(AppFont font) async {
    emit(state.copyWith(appFont: font));

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("font", font.index);
  }

  // -------------------------
  // تغيير حجم الخط
  // -------------------------
  void changeFontScale(double scale) async {
    final fixed = scale.clamp(0.8, 1.6);

    emit(state.copyWith(fontScale: fixed));

    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble("fontScale", fixed);
  }

  // -------------------------
  // إرجاع اسم الخط
  // -------------------------
  String get currentFont {
    switch (state.appFont) {
      case AppFont.amiri:
        return "Amiri";
      case AppFont.noto:
        return "Noto";
      case AppFont.scheherazade:
        return "Scheherazade";
      default:
        return "Cairo";
    }
  }
}
