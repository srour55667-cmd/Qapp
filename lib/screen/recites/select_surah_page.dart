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
    return Scaffold(
      appBar: AppBar(title: Text("اختر السورة"), centerTitle: true),
      body: ListView.builder(
        itemCount: moshaf.surahList.length,
        itemBuilder: (context, index) {
          final surahNumber = moshaf.surahList[index];
          final surahName = arabicSuraNames[surahNumber - 1];

          return ListTile(
            title: Text(
              "$surahName",
              style: TextStyle(
                fontSize: 18,
                color: Colors.purple.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Icon(Icons.play_arrow, color: Colors.purple),
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
          );
        },
      ),
    );
  }
}
