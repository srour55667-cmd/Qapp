// import 'package:flutter/material.dart';
// import 'package:qapp/model/Recitersmodel.dart';
// import 'package:qapp/screen/recites/surah_reciter_audio_page.dart';

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
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.purple.shade100.withOpacity(0.4),
//                   blurRadius: 10,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   radius: 24,
//                   backgroundColor: Colors.purple.shade300,
//                   child: Text(
//                     "${m.id}",
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Text(
//                     m.name,
//                     style: const TextStyle(
//                       fontSize: 17,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.purple,
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(
//                     Icons.arrow_forward_ios,
//                     color: Colors.purple,
//                   ),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) =>
//                             SurahReciterAudioPage(moshaf: m, reciter: reciter),
//                       ),
//                     );
//                   },
//                 ),
//               ],
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
    return Scaffold(
      appBar: AppBar(title: Text(reciter.name), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: reciter.moshaf.length,
        itemBuilder: (context, index) {
          final m = reciter.moshaf[index];

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              title: Text(
                m.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.purple,
              ),
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
