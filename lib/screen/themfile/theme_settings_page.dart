import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qapp/data/cubit/themcubit.dart';
import 'package:qapp/screen/debug/notifications_test_screen.dart';

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("الإعدادات"), centerTitle: true),
      body: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          final cubit = context.read<ThemeCubit>();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ---------------------------
              // Theme Section
              // ---------------------------
              const Text(
                "المظهر (Theme)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 12),

              _themeTile(
                title: "حسب النظام",
                value: AppTheme.system,
                groupValue: state.appTheme,
                onChanged: cubit.changeTheme,
              ),
              _themeTile(
                title: "الوضع الفاتح",
                value: AppTheme.light,
                groupValue: state.appTheme,
                onChanged: cubit.changeTheme,
              ),
              _themeTile(
                title: "الوضع الداكن",
                value: AppTheme.dark,
                groupValue: state.appTheme,
                onChanged: cubit.changeTheme,
              ),
              _themeTile(
                title: "وضع القراءة (سيبيا)",
                value: AppTheme.sepia,
                groupValue: state.appTheme,
                onChanged: cubit.changeTheme,
              ),

              const SizedBox(height: 24),

              // ---------------------------
              // Font Section
              // ---------------------------
              const Text(
                "نوع الخط (Font)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 12),

              _fontTile(
                title: "Cairo",
                value: AppFont.cairo,
                groupValue: state.appFont,
                onChanged: cubit.changeFont,
              ),
              _fontTile(
                title: "Amiri (قراءة)",
                value: AppFont.amiri,
                groupValue: state.appFont,
                onChanged: cubit.changeFont,
              ),
              _fontTile(
                title: "Noto Naskh",
                value: AppFont.noto,
                groupValue: state.appFont,
                onChanged: cubit.changeFont,
              ),
              _fontTile(
                title: "Scheherazade",
                value: AppFont.scheherazade,
                groupValue: state.appFont,
                onChanged: cubit.changeFont,
              ),

              const SizedBox(height: 24),

              // Hidden Debug Entry
              GestureDetector(
                onLongPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsTestScreen(),
                    ),
                  );
                },
                child: const Center(
                  child: Text(
                    "إصدار التطبيق: 1.0.0",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ------------------------------------------------
  // RADIO TILE FOR THEME
  // ------------------------------------------------
  Widget _themeTile({
    required String title,
    required AppTheme value,
    required AppTheme groupValue,
    required Function(AppTheme) onChanged,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: RadioListTile<AppTheme>(
        value: value,
        groupValue: groupValue,
        onChanged: (v) => onChanged(v!),
        title: Text(title, textAlign: TextAlign.right),
      ),
    );
  }

  // ------------------------------------------------
  // RADIO TILE FOR FONT
  // ------------------------------------------------
  Widget _fontTile({
    required String title,
    required AppFont value,
    required AppFont groupValue,
    required Function(AppFont) onChanged,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: RadioListTile<AppFont>(
        value: value,
        groupValue: groupValue,
        onChanged: (v) => onChanged(v!),
        title: Text(title, textAlign: TextAlign.right),
      ),
    );
  }
}
