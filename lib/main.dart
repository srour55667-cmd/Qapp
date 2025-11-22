// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:qapp/data/cubit/home_cubit.dart';
// import 'package:qapp/screen/splashscreen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (BuildContext context) {
//         return HomeCubit();
//       },
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: const Splashscreen(),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Cubits
import 'package:qapp/data/cubit/themcubit.dart';
import 'package:qapp/data/cubit/home_cubit.dart';

// Screens
import 'package:qapp/screen/homepage.dart';
import 'package:qapp/screen/themfile/app_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => HomeCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // هنا حل مشكلة الكراش
  TextTheme _scaledTextTheme(TextTheme base, double scale) {
    double safe(double? size) => (size ?? 16) * scale;

    return TextTheme(
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: safe(base.bodyLarge?.fontSize),
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: safe(base.bodyMedium?.fontSize),
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontSize: safe(base.bodySmall?.fontSize),
      ),

      titleLarge: base.titleLarge?.copyWith(
        fontSize: safe(base.titleLarge?.fontSize),
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontSize: safe(base.titleMedium?.fontSize),
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontSize: safe(base.titleSmall?.fontSize),
      ),

      labelLarge: base.labelLarge?.copyWith(
        fontSize: safe(base.labelLarge?.fontSize),
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontSize: safe(base.labelMedium?.fontSize),
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontSize: safe(base.labelSmall?.fontSize),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final cubit = context.read<ThemeCubit>();

        // الأساسيات
        ThemeData lightBase = AppThemes.lightTheme;
        ThemeData darkBase = AppThemes.darkTheme;
        ThemeData sepiaBase = AppThemes.sepiaTheme;

        // تكبير الخطوط مع حماية من الكراش
        final light = lightBase.copyWith(
          textTheme: _scaledTextTheme(
            lightBase.textTheme,
            state.fontScale,
          ).apply(fontFamily: cubit.currentFont),
        );

        final dark = darkBase.copyWith(
          textTheme: _scaledTextTheme(
            darkBase.textTheme,
            state.fontScale,
          ).apply(fontFamily: cubit.currentFont),
        );

        final sepia = sepiaBase.copyWith(
          textTheme: _scaledTextTheme(
            sepiaBase.textTheme,
            state.fontScale,
          ).apply(fontFamily: cubit.currentFont),
        );

        final ThemeData finalLight = state.appTheme == AppTheme.sepia
            ? sepia
            : light;

        return MaterialApp(
          debugShowCheckedModeBanner: false,

          themeMode: state.themeMode,
          theme: finalLight,
          darkTheme: dark,

          home: const HomePage(),
        );
      },
    );
  }
}
