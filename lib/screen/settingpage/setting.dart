// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:qapp/data/cubit/themcubit.dart';

// class SettingsPage extends StatelessWidget {
//   const SettingsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("الإعدادات"), centerTitle: true),

//       body: BlocBuilder<ThemeCubit, ThemeState>(
//         builder: (context, state) {
//           final cubit = context.read<ThemeCubit>();

//           return ListView(
//             padding: const EdgeInsets.all(20),
//             children: [
//               // ---------------------------------
//               //   قسم الثيم (Theme Mode)
//               // ---------------------------------
//               const _SectionTitle("المظهر (Theme)"),

//               _themeOption(
//                 context,
//                 title: "حسب النظام",
//                 value: AppTheme.system,
//                 selected: state.appTheme,
//                 onTap: () => cubit.changeTheme(AppTheme.system),
//                 icon: Icons.settings_suggest,
//               ),
//               _themeOption(
//                 context,
//                 title: "الوضع الفاتح",
//                 value: AppTheme.light,
//                 selected: state.appTheme,
//                 onTap: () => cubit.changeTheme(AppTheme.light),
//                 icon: Icons.light_mode,
//               ),
//               _themeOption(
//                 context,
//                 title: "الوضع الداكن",
//                 value: AppTheme.dark,
//                 selected: state.appTheme,
//                 onTap: () => cubit.changeTheme(AppTheme.dark),
//                 icon: Icons.dark_mode,
//               ),
//               _themeOption(
//                 context,
//                 title: "وضع القراءة (سيبيا)",
//                 value: AppTheme.sepia,
//                 selected: state.appTheme,
//                 onTap: () => cubit.changeTheme(AppTheme.sepia),
//                 icon: Icons.book,
//               ),

//               const SizedBox(height: 25),

//               // ---------------------------------
//               //   قسم الخط
//               // ---------------------------------
//               const _SectionTitle("نوع الخط (Font)"),

//               _fontOption(
//                 context,
//                 title: "Cairo",
//                 value: AppFont.cairo,
//                 selected: state.appFont,
//                 onTap: () => cubit.changeFont(AppFont.cairo),
//               ),
//               _fontOption(
//                 context,
//                 title: "Amiri (للقرآن)",
//                 value: AppFont.amiri,
//                 selected: state.appFont,
//                 onTap: () => cubit.changeFont(AppFont.amiri),
//               ),
//               _fontOption(
//                 context,
//                 title: "Noto Naskh",
//                 value: AppFont.noto,
//                 selected: state.appFont,
//                 onTap: () => cubit.changeFont(AppFont.noto),
//               ),
//               _fontOption(
//                 context,
//                 title: "Scheherazade",
//                 value: AppFont.scheherazade,
//                 selected: state.appFont,
//                 onTap: () => cubit.changeFont(AppFont.scheherazade),
//               ),

//               const SizedBox(height: 25),

//               // ---------------------------------
//               //   حجم الخط
//               // ---------------------------------
//               const _SectionTitle("حجم الخط (Font Size)"),

//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Slider(
//                         value: state.fontScale.clamp(0.8, 1.6),
//                         min: 0.8,
//                         max: 1.6,
//                         divisions: 8,
//                         activeColor: Theme.of(context).colorScheme.primary,
//                         label: state.fontScale.toStringAsFixed(1),
//                         onChanged: (v) {
//                           context.read<ThemeCubit>().changeFontScale(v);
//                         },
//                       ),
//                       Text(
//                         "معاينة النص",
//                         style: TextStyle(
//                           fontFamily: cubit.currentFont,
//                           fontSize: 18 * state.fontScale,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 35),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   // ===========================
//   //   عناصر UI صغيرة
//   // ===========================

//   Widget _themeOption(
//     BuildContext context, {
//     required String title,
//     required AppTheme value,
//     required AppTheme selected,
//     required IconData icon,
//     required VoidCallback onTap,
//   }) {
//     final primary = Theme.of(context).colorScheme.primary;

//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: ListTile(
//         leading: Icon(icon, color: primary),
//         title: Text(title, textAlign: TextAlign.right),
//         trailing: Radio<AppTheme>(
//           value: value,
//           activeColor: primary,
//           groupValue: selected,
//           onChanged: (_) => onTap(),
//         ),
//         onTap: onTap,
//       ),
//     );
//   }

//   Widget _fontOption(
//     BuildContext context, {
//     required String title,
//     required AppFont value,
//     required AppFont selected,
//     required VoidCallback onTap,
//   }) {
//     final primary = Theme.of(context).colorScheme.primary;

//     return Card(
//       margin: const EdgeInsets.only(bottom: 10),
//       child: ListTile(
//         leading: Icon(Icons.text_fields, color: primary),
//         title: Text(title, textAlign: TextAlign.right),
//         trailing: Radio<AppFont>(
//           value: value,
//           groupValue: selected,
//           activeColor: primary,
//           onChanged: (_) => onTap(),
//         ),
//         onTap: onTap,
//       ),
//     );
//   }
// }

// class _SectionTitle extends StatelessWidget {
//   final String text;

//   const _SectionTitle(this.text, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Text(
//         text,
//         textAlign: TextAlign.right,
//         style: TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//           color: Theme.of(context).colorScheme.primary,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
