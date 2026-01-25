import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:qapp/model/Recitersmodel.dart';
import 'package:qapp/model/surah_nameAr.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SurahReciterAudioPage extends StatefulWidget {
  final Moshaf moshaf;
  final Reciter reciter;
  final int initialSurahIndex;

  const SurahReciterAudioPage({
    super.key,
    required this.moshaf,
    required this.reciter,
    required this.initialSurahIndex,
  });

  @override
  State<SurahReciterAudioPage> createState() => _SurahReciterAudioPageState();
}

class _SurahReciterAudioPageState extends State<SurahReciterAudioPage> {
  late AudioPlayer _player;
  StreamSubscription? _stateSub;
  StreamSubscription? _durationSub;
  StreamSubscription? _positionSub;
  StreamSubscription? _completeSub;

  late int currentIndex;
  bool _autoPlayNext = true;
  static const String _autoPlayKey = 'auto_play_next_surah';

  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();

    _player = AudioPlayer();
    currentIndex = widget.initialSurahIndex;

    _stateSub = _player.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() => isPlaying = state == PlayerState.playing);
    });

    _durationSub = _player.onDurationChanged.listen((d) {
      if (!mounted) return;
      setState(() => duration = d);
    });

    _positionSub = _player.onPositionChanged.listen((p) {
      if (!mounted) return;
      setState(() => position = p);
    });

    _completeSub = _player.onPlayerComplete.listen((event) {
      if (_autoPlayNext && mounted) {
        // If current surah is 114 (index 113), we stop.
        // Otherwise, play next.
        // Moshaf list might handle indices differently, but typically logic is:
        if (currentIndex < widget.moshaf.surahList.length - 1) {
          next();
        }
      }
    });

    _loadAutoPlayPreference();
    playCurrent();
  }

  Future<void> _loadAutoPlayPreference() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _autoPlayNext = prefs.getBool(_autoPlayKey) ?? true;
    });
  }

  Future<void> _toggleAutoPlay(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoPlayKey, value);
    if (!mounted) return;
    setState(() {
      _autoPlayNext = value;
    });
  }

  Future<void> playCurrent() async {
    try {
      final surahNum = widget.moshaf.surahList[currentIndex];
      final url =
          "${widget.moshaf.server}/${surahNum.toString().padLeft(3, '0')}.mp3";

      await _player.stop();
      await _player.play(UrlSource(url));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error playing audio: $e")));
      }
    }
  }

  Future<void> next() async {
    if (currentIndex < widget.moshaf.surahList.length - 1) {
      currentIndex++;
      await playCurrent();
      if (mounted) setState(() {});
    }
  }

  Future<void> previous() async {
    if (currentIndex > 0) {
      currentIndex--;
      await playCurrent();
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    _stateSub?.cancel();
    _durationSub?.cancel();
    _positionSub?.cancel();
    _completeSub?.cancel();
    _player.dispose();
    super.dispose();
  }

  String fmt(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    final surahNum = widget.moshaf.surahList[currentIndex];
    final surahName = arabicSuraNames[surahNum - 1];

    return Scaffold(
      appBar: AppBar(title: Text("سورة $surahName"), centerTitle: true),

      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primary.withOpacity(0.10), primary.withOpacity(0.03)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),

              /// -----------------------------
              ///  عنوان السورة
              /// -----------------------------
              Text(
                "سورة $surahName",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primary,
                  fontFamily: "Amiri",
                ),
              ),

              const SizedBox(height: 6),

              Text(
                widget.reciter.name,
                style: TextStyle(
                  fontSize: 18,
                  color: onSurface.withOpacity(0.8),
                ),
              ),

              const SizedBox(height: 40),

              /// -----------------------------
              ///      شريط التقدم
              /// -----------------------------
              Slider(
                activeColor: primary,
                inactiveColor: primary.withOpacity(0.3),
                value: position.inSeconds
                    .clamp(0, duration.inSeconds)
                    .toDouble(),
                min: 0,
                max: duration.inSeconds.toDouble() + 1,
                onChanged: (value) {
                  _player.seek(Duration(seconds: value.toInt()));
                },
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(fmt(position), style: TextStyle(color: onSurface)),
                    Text(fmt(duration), style: TextStyle(color: onSurface)),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              /// -----------------------------
              ///       أزرار التحكم
              /// -----------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 38,
                    color: primary,
                    icon: const Icon(Icons.skip_previous_rounded),
                    onPressed: previous,
                  ),

                  const SizedBox(width: 25),

                  /// زر التشغيل الدائري
                  InkWell(
                    onTap: () {
                      isPlaying ? _player.pause() : _player.resume();
                    },
                    borderRadius: BorderRadius.circular(80),
                    child: Container(
                      height: 80,
                      width: 80,
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
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(width: 25),

                  IconButton(
                    iconSize: 38,
                    color: primary,
                    icon: const Icon(Icons.skip_next_rounded),
                    onPressed: next,
                  ),
                ],
              ),

              const SizedBox(height: 50),
              const SizedBox(height: 30),

              /// -----------------------------
              ///    مفتاح التشغيل التلقائي
              /// -----------------------------
              SwitchListTile(
                title: const Text(
                  "تشغيل السورة التالية تلقائيًا",
                  style: TextStyle(
                    fontFamily: "Cairo",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                activeColor: primary,
                value: _autoPlayNext,
                onChanged: _toggleAutoPlay,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
