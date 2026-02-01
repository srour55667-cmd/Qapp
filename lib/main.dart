import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qapp/data/cubit/dhikr_cubit.dart';

// Cubits
import 'package:qapp/data/cubit/themcubit.dart';
import 'package:qapp/data/cubit/home_cubit.dart';
import 'package:qapp/data/cubit/reading_progress_cubit.dart';

// Screens
import 'package:qapp/screen/splashscreen.dart';
import 'package:qapp/screen/themfile/app_themes.dart';

import 'package:timezone/data/latest.dart' as tz;

import 'package:qapp/services/app_bootstrapper.dart';

void main() async {
  final stopwatch = Stopwatch()..start();
  print('Startup: main() started at ${stopwatch.elapsedMilliseconds}ms');

  // 1. Critical Init
  tz.initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();
  print('Startup: Binding & TZ init took ${stopwatch.elapsedMilliseconds}ms');

  // 2. Start Bootstrapper (handles heavy background work)
  AppBootstrapper.init();

  // 3. Launch App immediately
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => HomeCubit()),
        BlocProvider(create: (_) => DhikrCubit()),
        BlocProvider(create: (_) => ReadingProgressCubit()..loadProgress()),
      ],
      child: const MyApp(),
    ),
  );
  print('Startup: runApp called at ${stopwatch.elapsedMilliseconds}ms');
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

        // Determine base light theme (Standard or Sepia)
        ThemeData lightBase = state.appTheme == AppTheme.sepia
            ? AppThemes.sepiaTheme
            : AppThemes.lightTheme;
        ThemeData darkBase = AppThemes.darkTheme;

        // Apply Font & Scale to Light/Sepia Theme
        final light = lightBase.copyWith(
          textTheme: _scaledTextTheme(
            lightBase.textTheme,
            state.fontScale,
          ).apply(fontFamily: cubit.currentFont),
        );

        // Apply Font & Scale to Dark Theme
        final dark = darkBase.copyWith(
          textTheme: _scaledTextTheme(
            darkBase.textTheme,
            state.fontScale,
          ).apply(fontFamily: cubit.currentFont),
        );

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: state.themeMode,
          theme: light,
          darkTheme: dark,
          home: const Splashscreen(),
        );
      },
    );
  }
}
