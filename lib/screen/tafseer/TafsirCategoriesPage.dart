// import 'package:flutter/material.dart';
// import 'package:qapp/screen/tafseer/TafsirSurahListPage.dart';

// class TafsirCategoriesPage extends StatelessWidget {
//   const TafsirCategoriesPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // أنواع التفسير المتاحة
//     final List<Map<String, dynamic>> tafsirList = [
//       {"name": "التفسير الميسر", "code": "arabic_moyassar", "enabled": true},
//       {"name": "تفسير السعدي", "code": "arabic_saad", "enabled": false},
//       {"name": "تفسير الطبري", "code": "arabic_tabari", "enabled": false},
//       {"name": "تفسير ابن كثير", "code": "arabic_ibnkatheer", "enabled": false},
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("اختر نوع التفسير"),
//         centerTitle: true,
//         backgroundColor: Colors.purple,
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: tafsirList.length,
//         itemBuilder: (context, index) {
//           final item = tafsirList[index];

//           return GestureDetector(
//             onTap: () {
//               if (item["enabled"] == true) {
//                 // فقط التفسير الميسر يعمل
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => TafsirSurahListPage(
//                       tafsirName: item["name"],
//                       tafsirCode: item["code"],
//                     ),
//                   ),
//                 );
//               } else {
//                 // باقي التفاسير: رسالة فقط
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     backgroundColor: Colors.purple,
//                     content: const Text(
//                       "التفسيرات الأخرى قيد الإضافة",
//                       textAlign: TextAlign.center,
//                     ),
//                     duration: Duration(seconds: 2),
//                   ),
//                 );
//               }
//             },
//             child: Container(
//               margin: const EdgeInsets.only(bottom: 15),
//               padding: const EdgeInsets.all(18),
//               decoration: BoxDecoration(
//                 color: Colors.purple.shade50,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Text(
//                 item["name"],
//                 style: TextStyle(
//                   color: item["enabled"]
//                       ? Colors.purple.shade700
//                       : Colors.grey.shade600,
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:qapp/screen/tafseer/TafsirSurahListPage.dart';

class TafsirCategoriesPage extends StatelessWidget {
  const TafsirCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final cardColor = Theme.of(context).cardColor;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    final List<Map<String, dynamic>> tafsirList = [
      {"name": "التفسير الميسر", "code": "arabic_moyassar", "enabled": true},
      {"name": "تفسير السعدي", "code": "arabic_saad", "enabled": false},
      {"name": "تفسير الطبري", "code": "arabic_tabari", "enabled": false},
      {"name": "تفسير ابن كثير", "code": "arabic_ibnkatheer", "enabled": false},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("اختر نوع التفسير"), centerTitle: true),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tafsirList.length,
        itemBuilder: (context, index) {
          final item = tafsirList[index];

          return AnimatedContainer(
            duration: Duration(milliseconds: 350 + index * 50),
            curve: Curves.easeOut,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),

            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),

              title: Text(
                item["name"],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: item["enabled"] ? primary : onSurface.withOpacity(0.6),
                ),
              ),

              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: item["enabled"] ? primary : onSurface.withOpacity(0.4),
              ),

              onTap: () {
                if (item["enabled"] == true) {
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("التفاسير الأخرى ستتوفر قريبًا"),
                      backgroundColor: primary,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
