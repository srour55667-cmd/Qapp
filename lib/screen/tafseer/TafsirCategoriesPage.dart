import 'package:flutter/material.dart';
import 'package:qapp/screen/tafseer/TafsirSurahListPage.dart';

class TafsirCategoriesPage extends StatelessWidget {
  const TafsirCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // أنواع التفسير المتاحة
    final List<Map<String, dynamic>> tafsirList = [
      {"name": "التفسير الميسر", "code": "arabic_moyassar", "enabled": true},
      {"name": "تفسير السعدي", "code": "arabic_saad", "enabled": false},
      {"name": "تفسير الطبري", "code": "arabic_tabari", "enabled": false},
      {"name": "تفسير ابن كثير", "code": "arabic_ibnkatheer", "enabled": false},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("اختر نوع التفسير"),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tafsirList.length,
        itemBuilder: (context, index) {
          final item = tafsirList[index];

          return GestureDetector(
            onTap: () {
              if (item["enabled"] == true) {
                // فقط التفسير الميسر يعمل
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TafsirSurahListPage(
                      tafsirName: item["name"],
                      tafsirCode: item["code"],
                    ),
                  ),
                );
              } else {
                // باقي التفاسير: رسالة فقط
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.purple,
                    content: const Text(
                      "التفسيرات الأخرى قيد الإضافة",
                      textAlign: TextAlign.center,
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                item["name"],
                style: TextStyle(
                  color: item["enabled"]
                      ? Colors.purple.shade700
                      : Colors.grey.shade600,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
