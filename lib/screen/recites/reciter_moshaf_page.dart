// import 'package:flutter/material.dart';
// import 'package:qapp/model/Recitersmodel.dart';
// import 'package:qapp/screen/recites/select_surah_page.dart';

// class ReciterMoshafPage extends StatelessWidget {
//   final Reciter reciter;

//   const ReciterMoshafPage({super.key, required this.reciter});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(reciter.name), centerTitle: true),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(12),
//         itemCount: reciter.moshaf.length,
//         itemBuilder: (context, index) {
//           final m = reciter.moshaf[index];

//           return Container(
//             margin: const EdgeInsets.symmetric(vertical: 10),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.purple.shade50,
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: ListTile(
//               title: Text(
//                 m.name,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.purple,
//                 ),
//               ),
//               trailing: const Icon(
//                 Icons.arrow_forward_ios,
//                 color: Colors.purple,
//               ),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) =>
//                         SelectSurahPage(moshaf: m, reciter: reciter),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:qapp/model/Recitersmodel.dart';
import 'package:qapp/screen/recites/select_surah_page.dart';

class ReciterMoshafPage extends StatelessWidget {
  final Reciter reciter;

  const ReciterMoshafPage({super.key, required this.reciter});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final cardColor = Theme.of(context).cardColor;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(title: Text(reciter.name), centerTitle: true),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reciter.moshaf.length,
        itemBuilder: (context, index) {
          final m = reciter.moshaf[index];

          return AnimatedContainer(
            duration: Duration(milliseconds: 300 + index * 40),
            curve: Curves.easeOut,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),

            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),

              leading: CircleAvatar(
                radius: 26,
                backgroundColor: primary.withOpacity(0.15),
                child: Icon(Icons.menu_book_rounded, color: primary),
              ),

              title: Text(
                m.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: onSurface,
                ),
              ),

              trailing: Icon(Icons.arrow_forward_ios_rounded, color: primary),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        SelectSurahPage(moshaf: m, reciter: reciter),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
