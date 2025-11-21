import 'package:flutter/material.dart';
import 'package:qapp/model/surah_nameAr.dart';
import 'package:qapp/screen/tafseer/TafsirResultPage.dart';

class TafsirSurahListPage extends StatelessWidget {
  final String tafsirName;
  final String tafsirCode;

  const TafsirSurahListPage({
    super.key,
    required this.tafsirName,
    required this.tafsirCode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("سور القرآن - $tafsirName"),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: ListView.separated(
        itemCount: arabicSuraNames.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final surahName = arabicSuraNames[index];
          final surahNumber = index + 1;

          return ListTile(
            title: Text(
              surahName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 18),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TafsirResultPage(
                    tafsirCode: tafsirCode,
                    surahNumber: surahNumber,
                    surahName: surahName,
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
