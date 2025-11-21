import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:qapp/model/radio_model.dart';

class ListviewCategoryRadio extends StatefulWidget {
  const ListviewCategoryRadio({super.key, required this.surahList});

  final List<RadioModel> surahList;

  @override
  State<ListviewCategoryRadio> createState() => _ListviewCategoryRadioState();
}

class _ListviewCategoryRadioState extends State<ListviewCategoryRadio> {
  late final AudioPlayer player;

  int? _currentIndex;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();

    // تحدّيث الحالة كلما تغيّرت حالة المشغّل
    player.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _isPlaying = state == PlayerState.playing;
        if (state == PlayerState.stopped || state == PlayerState.completed) {
          _currentIndex = null;
        }
      });
    });
  }

  Future<void> playAt(int index) async {
    final url = widget.surahList[index].url;
    // أوقف أي تشغيل حالي أولاً
    await player.stop();
    // شغّل المصدر الجديد
    await player.play(UrlSource(url));
    if (!mounted) return;
    setState(() {
      _currentIndex = index;
      // ⚠️ لا تستدعي dispose هنا!
    });
  }

  Future<void> pause() async => player.pause();
  Future<void> resume() async => player.resume();

  Future<void> stop() async {
    await player.stop();
    if (!mounted) return;
    setState(() => _currentIndex = null);
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.surahList.length,
      itemBuilder: (context, index) {
        final item = widget.surahList[index];
        final isThisPlaying = _isPlaying && _currentIndex == index;

        return _categoryItem(
          numSurah: index + 1,
          surahNameArb: item.name,
          onPlayPause: () {
            if (_currentIndex == index) {
              isThisPlaying ? pause() : resume();
            } else {
              playAt(index);
            }
          },
          onStop: stop,
          isPlaying: isThisPlaying,
        );
      },
    );
  }

  Widget _categoryItem({
    required int numSurah,
    required String surahNameArb,
    required VoidCallback onPlayPause,
    required VoidCallback onStop,
    required bool isPlaying,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 4,
            height: 70,
            decoration: const BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ListTile(
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.purple),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$numSurah',
                  style: const TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                surahNameArb,
                style: const TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: onPlayPause,
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.purple,
                    ),
                  ),
                  IconButton(
                    onPressed: onStop,
                    icon: const Icon(Icons.stop, color: Colors.purple),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
