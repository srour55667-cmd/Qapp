// import 'package:flutter/material.dart';
// import 'package:qapp/data/azkar/azkar_datamain.dart';
// import 'package:qapp/screen/azkar/AzkarListPage.dart';

// class AzkarCategoriesPage extends StatelessWidget {
//   const AzkarCategoriesPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final categories = azkarData.keys.toList();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("الأذكار"),
//         centerTitle: true,
//         backgroundColor: Colors.purple,
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: categories.length,
//         itemBuilder: (context, index) {
//           final category = categories[index];

//           return GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => AzkarListPage(
//                     title: category,
//                     items: azkarData[category] ?? [],
//                   ),
//                 ),
//               );
//             },
//             child: Container(
//               margin: const EdgeInsets.only(bottom: 20),
//               padding: const EdgeInsets.all(18),
//               decoration: BoxDecoration(
//                 color: Colors.purple.shade50,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Text(
//                 category,
//                 style: TextStyle(
//                   color: Colors.purple.shade700,
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
import 'package:qapp/data/azkar/azkar_datamain.dart';
import 'package:qapp/screen/azkar/AzkarListPage.dart';

class AzkarCategoriesPage extends StatelessWidget {
  const AzkarCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = azkarData.keys.toList();
    final primary = Theme.of(context).colorScheme.primary;
    final cardColor = Theme.of(context).cardColor;

    return Scaffold(
      appBar: AppBar(title: const Text("الأذكار"), centerTitle: true),

      body: Container(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 18,
            childAspectRatio: 0.95,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];

            return InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AzkarListPage(
                      title: category,
                      items: azkarData[category] ?? [],
                    ),
                  ),
                );
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 350 + (index * 40)),
                curve: Curves.easeOut,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: primary.withOpacity(0.15),
                      child: Icon(
                        Icons.menu_book_rounded,
                        color: primary,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      category,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
