import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qapp/model/Recitersmodel.dart';
import 'package:qapp/model/suwer_nameEng_model.dart';

class SurahListPage extends StatefulWidget {
  final String reciterName;
  final Moshaf moshaf;
  const SurahListPage({
    super.key,
    required this.reciterName,
    required this.moshaf,
  });

  @override
  State<SurahListPage> createState() => _SurahListPageState();
}

class _SurahListPageState extends State<SurahListPage> {
  final AudioPlayer _player = AudioPlayer();
  int? _currentPlaying;

  List<int> get _surahNumbers {
    final list = widget.moshaf.surahList;
    if (list.isNotEmpty) return list;
    return List.generate(114, (i) => i + 1);
  }

  String _buildUrl(int surahNumber) {
    final base = widget.moshaf.server.endsWith('/')
        ? widget.moshaf.server
        : '${widget.moshaf.server}/';
    final file = surahNumber.toString().padLeft(3, '0');
    return '$base$file.mp3';
  }

  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) {
      setState(() => _currentPlaying = null);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final numbers = _surahNumbers;

    return Scaffold(
      appBar: AppBar(title: Text(widget.reciterName)),
      body: ListView.builder(
        itemCount: numbers.length,
        itemBuilder: (context, index) {
          final surahNumber = numbers[index];
          final surahName = Name_Eng[surahNumber - 1]; // 1-based -> 0-based

          final isPlaying = _currentPlaying == surahNumber;

          return ListTile(
            title: Text("$surahNumber. $surahName"),
            trailing: IconButton(
              icon: Icon(
                isPlaying ? Icons.stop : Icons.play_arrow,
                color: Colors.green,
              ),
              onPressed: () async {
                if (isPlaying) {
                  await _player.stop();
                  setState(() => _currentPlaying = null);
                } else {
                  final url = _buildUrl(surahNumber);
                  await _player.stop(); // اوقف أي تشغيل سابق
                  await _player.play(UrlSource(url));
                  setState(() => _currentPlaying = surahNumber);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
