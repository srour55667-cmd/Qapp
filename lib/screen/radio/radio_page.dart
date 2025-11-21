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

    /// LISTENER آمن ومضبوط 100%
    _stateSub = _player.onPlayerStateChanged.listen((state) {
      if (!mounted) return; // يمنع الكراش بعد غلق الصفحة

      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });
  }

  Future<void> playRadio(int index) async {
    final url = widget.radios[index].url;

    await _player.stop();
    await _player.play(UrlSource(url));

    if (!mounted) return;

    setState(() {
      _currentIndex = index;
    });
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
    /// أوقف كل شيء قبل الإغلاق
    _stateSub?.cancel();
    _player.stop();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quran Radio", style: TextStyle(fontSize: 20)),
        centerTitle: true,
      ),

      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: widget.radios.length,
          itemBuilder: (context, index) {
            final radio = widget.radios[index];
            final isThisPlaying = _currentIndex == index && _isPlaying;

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.shade100.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: Row(
                children: [
                  // الرقم التسلسلي
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.purple.shade300,
                    child: Text(
                      "${index + 1}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // اسم الإذاعة
                  Expanded(
                    child: Text(
                      radio.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  ),

                  // تشغيل / إيقاف
                  IconButton(
                    icon: Icon(
                      isThisPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.purple,
                      size: 30,
                    ),
                    onPressed: () {
                      if (isThisPlaying) {
                        _player.pause();
                        setState(() => _isPlaying = false);
                      } else {
                        playRadio(index);
                      }
                    },
                  ),

                  // Stop
                  IconButton(
                    icon: const Icon(Icons.stop, color: Colors.red),
                    onPressed: stopRadio,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
