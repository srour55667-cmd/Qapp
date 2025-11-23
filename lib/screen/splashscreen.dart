// import 'package:flutter/material.dart';
// import 'package:qapp/screen/homepage.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Splashscreen extends StatefulWidget {
//   const Splashscreen({super.key});

//   @override
//   State<Splashscreen> createState() => _SplashscreenState();
// }

// class _SplashscreenState extends State<Splashscreen> {
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(const Duration(seconds: 3), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const HomePage()),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       final prefs = await SharedPreferences.getInstance();
// final city = prefs.getString("selected_city") ?? "Cairo";
// HomeCubit().getPrayerTimes(city);
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // الصورة — كبرناها وخليّناها أوضح
//             Padding(
//               padding: const EdgeInsets.all(25),
//               child: Image.asset(
//                 "assets/images/logo.png",
//                 width: 240, // كان 180
//                 height: 240, // كان 180
//                 fit: BoxFit.contain,
//               ),
//             ),

//             const SizedBox(height: 10),

//             // اسم التطبيق الجديد
//             const Text(
//               "آيات",
//               style: TextStyle(
//                 fontSize: 36, // أكبر + أوضح
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF9543FF),
//               ),
//             ),

//             const SizedBox(height: 8),

//             // الوصف
//             const Text(
//               "منصة إسلامية شاملة للمسلمين",
//               style: TextStyle(
//                 fontSize: 17,
//                 fontWeight: FontWeight.w500,
//                 color: Color(0xFFA8A8A8),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:qapp/screen/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qapp/data/cubit/home_cubit.dart';

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

    // 3) انتقل للصفحة الرئيسية بعد 3 ثواني
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
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
