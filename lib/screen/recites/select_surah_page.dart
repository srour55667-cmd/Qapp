// import 'package:flutter/material.dart';
// import 'package:qapp/model/Recitersmodel.dart';
// import 'package:qapp/model/surah_nameAr.dart';
// import 'package:qapp/screen/recites/surah_reciter_audio_page.dart';

// class SelectSurahPage extends StatelessWidget {
//   final Moshaf moshaf;
//   final Reciter reciter;

//   const SelectSurahPage({
//     super.key,
//     required this.moshaf,
//     required this.reciter,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("اختر السورة"), centerTitle: true),
//       body: ListView.builder(
//         itemCount: moshaf.surahList.length,
//         itemBuilder: (context, index) {
//           final surahNumber = moshaf.surahList[index];
//           final surahName = arabicSuraNames[surahNumber - 1];

//           return ListTile(
//             title: Text(
//               "$surahName",
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.purple.shade700,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             trailing: const Icon(Icons.play_arrow, color: Colors.purple),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => SurahReciterAudioPage(
//                     moshaf: moshaf,
//                     reciter: reciter,
//                     initialSurahIndex: index,
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:qapp/model/Recitersmodel.dart';
import 'package:qapp/model/surah_nameAr.dart';
import 'package:qapp/screen/recites/surah_reciter_audio_page.dart';

class SelectSurahPage extends StatelessWidget {
  final Moshaf moshaf;
  final Reciter reciter;

  const SelectSurahPage({
    super.key,
    required this.moshaf,
    required this.reciter,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final cardColor = Theme.of(context).cardColor;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(title: Text("اختر السورة"), centerTitle: true),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: moshaf.surahList.length,
        itemBuilder: (context, index) {
          final surahNumber = moshaf.surahList[index];
          final surahName = arabicSuraNames[surahNumber - 1];

          return AnimatedContainer(
            duration: Duration(milliseconds: 250 + index * 40),
            curve: Curves.easeOut,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),

            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 12,
              ),

              title: Text(
                surahName,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: onSurface,
                ),
              ),

              trailing: CircleAvatar(
                radius: 20,
                backgroundColor: primary.withOpacity(0.15),
                child: Icon(Icons.play_arrow_rounded, color: primary, size: 26),
              ),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SurahReciterAudioPage(
                      moshaf: moshaf,
                      reciter: reciter,
                      initialSurahIndex: index,
                    ),
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
