import 'package:flutter/material.dart';
import 'package:qapp/screen/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qapp/data/cubit/home_cubit.dart';
import 'package:qapp/data/repository/quran_repository.dart';
import 'package:qapp/screen/surah/quran_init_page.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    // 1) اقرأ المدينة من SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final city = prefs.getString("selected_city") ?? "Cairo";

    // 2) جيب مواقيت الصلاة وجدول الإشعارات
    await HomeCubit().getPrayerTimes(city);

    // 3) تفقد جاهزية بيانات القرآن
    final isQuranReady = await QuranRepository.isQuranDataReady();

    // 4) انتقل للصفحة المطلوبة بعد تأخير بسيط
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      if (!isQuranReady) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const QuranInitPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(25),
              child: Image.asset(
                "assets/images/logo.png",
                width: 240,
                height: 240,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "آيات",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFF9543FF),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "منصة إسلامية شاملة للمسلمين",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Color(0xFFA8A8A8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
