import 'package:flutter/material.dart';
import 'package:qapp/screen/homepage.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
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
                "assets/images/quran1.png",
                width: 180,
                height: 180,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "تطبيق القرآن",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF9543FF),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "قراءة القرآن أصبحت أسهل",
              style: TextStyle(
                fontSize: 16,
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
