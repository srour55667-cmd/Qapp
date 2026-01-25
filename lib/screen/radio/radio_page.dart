import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:qapp/model/radio_model.dart';

class RadiosPage extends StatefulWidget {
  final List<RadioModel> radios;

  const RadiosPage({super.key, required this.radios});

  @override
  State<RadiosPage> createState() => _RadiosPageState();
}

class _RadiosPageState extends State<RadiosPage> {
  late AudioPlayer _player;
  StreamSubscription? _stateSub;

  int? _currentIndex;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    _player = AudioPlayer();

    _stateSub = _player.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });
  }

  Future<void> playRadio(int index) async {
    final url = widget.radios[index].url;

    if (url.isEmpty || !url.startsWith("http")) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("هذه الإذاعة غير متاحة حالياً"),
          backgroundColor: Colors.red.shade400,
        ),
      );
      return;
    }

    try {
      await _player.stop();
      await _player.setReleaseMode(ReleaseMode.stop);

      await _player.play(UrlSource(url), mode: PlayerMode.mediaPlayer);

      if (!mounted) return;
      setState(() => _currentIndex = index);
    } catch (e) {
      print(" Radio Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("تعذر تشغيل الإذاعة: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> stopRadio() async {
    await _player.stop();

    if (!mounted) return;

    setState(() {
      _currentIndex = null;
      _isPlaying = false;
    });
  }

  @override
  void dispose() {
    _stateSub?.cancel();
    _player.stop();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final cardColor = Theme.of(context).cardColor;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(
        title: const Text("إذاعات القرآن الكريم"),
        centerTitle: true,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.radios.length,
        itemBuilder: (context, index) {
          final radio = widget.radios[index];
          final bool isThisPlaying = _currentIndex == index && _isPlaying;

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),

            child: Row(
              children: [
                // ========== رقم الإذاعة ==========
                CircleAvatar(
                  radius: 26,
                  backgroundColor: primary.withOpacity(0.15),
                  child: Text(
                    "${index + 1}",
                    style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),

                const SizedBox(width: 18),

                // ========== اسم الإذاعة ==========
                Expanded(
                  child: Text(
                    radio.name,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: onSurface,
                    ),
                  ),
                ),

                // ========== زر التشغيل الدائري ==========
                InkWell(
                  onTap: () {
                    if (isThisPlaying) {
                      _player.pause();
                      setState(() => _isPlaying = false);
                    } else {
                      playRadio(index);
                    }
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primary,
                      boxShadow: [
                        BoxShadow(
                          color: primary.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(
                      isThisPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: isThisPlaying ? 30 : 34,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // ========== زر الإيقاف ==========
                // IconButton(
                //   onPressed: stopRadio,
                //   icon: Icon(
                //     Icons.stop_circle_rounded,
                //     color: Colors.red.shade400,
                //     size: 36,
                //   ),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}
