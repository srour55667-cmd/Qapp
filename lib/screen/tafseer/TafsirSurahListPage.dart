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
    final primary = Theme.of(context).colorScheme.primary;
    final cardColor = Theme.of(context).cardColor;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(
        title: Text("سور القرآن - $tafsirName"),
        centerTitle: true,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: arabicSuraNames.length,
        itemBuilder: (context, index) {
          final surahName = arabicSuraNames[index];
          final surahNumber = index + 1;

          return AnimatedContainer(
            duration: Duration(milliseconds: 300 + index * 50),
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(color: primary.withOpacity(0.10), blurRadius: 8),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),

              title: Text(
                surahName,
                style: TextStyle(
                  fontSize: 20,
                  color: onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),

              trailing: Icon(Icons.arrow_forward_ios_rounded, color: primary),

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
            ),
          );
        },
      ),
    );
  }
}
