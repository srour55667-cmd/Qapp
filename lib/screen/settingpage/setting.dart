import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qapp/data/cubit/dhikr_cubit.dart';
import 'package:qapp/data/cubit/themcubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("الإعدادات"), centerTitle: true),

      body: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          final cubit = context.read<ThemeCubit>();

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // -------------------------
              //   الثيم
              // -------------------------
              const _SectionTitle("المظهر (Theme)"),

              _themeOption(
                context,
                title: "حسب النظام",
                value: AppTheme.system,
                selected: state.appTheme,
                onTap: () => cubit.changeTheme(AppTheme.system),
                icon: Icons.settings_suggest,
              ),
              _themeOption(
                context,
                title: "الوضع الفاتح",
                value: AppTheme.light,
                selected: state.appTheme,
                onTap: () => cubit.changeTheme(AppTheme.light),
                icon: Icons.light_mode,
              ),
              _themeOption(
                context,
                title: "الوضع الداكن",
                value: AppTheme.dark,
                selected: state.appTheme,
                onTap: () => cubit.changeTheme(AppTheme.dark),
                icon: Icons.dark_mode,
              ),
              _themeOption(
                context,
                title: "وضع القراءة (سيبيا)",
                value: AppTheme.sepia,
                selected: state.appTheme,
                onTap: () => cubit.changeTheme(AppTheme.sepia),
                icon: Icons.book,
              ),

              const SizedBox(height: 25),

              // -------------------------
              //   نوع الخط
              // -------------------------
              const _SectionTitle("نوع الخط (Font)"),

              _fontOption(
                context,
                title: "Cairo",
                value: AppFont.cairo,
                selected: state.appFont,
                onTap: () => cubit.changeFont(AppFont.cairo),
              ),
              _fontOption(
                context,
                title: "Amiri (للقرآن)",
                value: AppFont.amiri,
                selected: state.appFont,
                onTap: () => cubit.changeFont(AppFont.amiri),
              ),
              _fontOption(
                context,
                title: "Noto Naskh",
                value: AppFont.noto,
                selected: state.appFont,
                onTap: () => cubit.changeFont(AppFont.noto),
              ),
              _fontOption(
                context,
                title: "Scheherazade",
                value: AppFont.scheherazade,
                selected: state.appFont,
                onTap: () => cubit.changeFont(AppFont.scheherazade),
              ),

              const SizedBox(height: 35),
              const _SectionTitle("إشعارات الذكر"),
              BlocBuilder<DhikrCubit, DhikrState>(
                builder: (context, state) {
                  return Card(
                    child: SwitchListTile(
                      title: const Text(
                        "تشغيل إشعارات الذكر ",
                        textAlign: TextAlign.right,
                      ),
                      value: state.enabled,
                      onChanged: (value) {
                        context.read<DhikrCubit>().toggleDhikr(value);
                      },
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _themeOption(
    BuildContext context, {
    required String title,
    required AppTheme value,
    required AppTheme selected,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final primary = Theme.of(context).colorScheme.primary;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: primary),
        title: Text(title, textAlign: TextAlign.right),
        trailing: Radio<AppTheme>(
          value: value,
          activeColor: primary,
          groupValue: selected,
          onChanged: (_) => onTap(),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _fontOption(
    BuildContext context, {
    required String title,
    required AppFont value,
    required AppFont selected,
    required VoidCallback onTap,
  }) {
    final primary = Theme.of(context).colorScheme.primary;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(Icons.text_fields, color: primary),
        title: Text(title, textAlign: TextAlign.right),
        trailing: Radio<AppFont>(
          value: value,
          groupValue: selected,
          activeColor: primary,
          onChanged: (_) => onTap(),
        ),
        onTap: onTap,
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
