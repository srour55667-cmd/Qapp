import 'package:flutter/material.dart';
import 'package:qapp/data/repository/quran_repository.dart';
import 'package:qapp/screen/homepage.dart';

class QuranInitPage extends StatefulWidget {
  const QuranInitPage({super.key});

  @override
  State<QuranInitPage> createState() => _QuranInitPageState();
}

class _QuranInitPageState extends State<QuranInitPage> {
  double _progress = 0.0;
  String _message = "جاري تحضير القرآن للاستخدام بدون إنترنت...";

  @override
  void initState() {
    super.initState();
    _startInitialization();
  }

  Future<void> _startInitialization() async {
    try {
      await QuranRepository.initQuranData(
        onProgress: (p) {
          setState(() {
            _progress = p;
          });
        },
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (e) {
      setState(() {
        _message = "حدث خطأ أثناء التحضير: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.library_books_rounded,
                size: 80,
                color: Color(0xFF9543FF),
              ),
              const SizedBox(height: 32),
              Text(
                _message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              LinearProgressIndicator(
                value: _progress,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF9543FF),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "${(_progress * 100).toInt()}%",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
