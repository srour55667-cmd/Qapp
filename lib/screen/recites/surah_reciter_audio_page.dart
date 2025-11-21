// import 'dart:async';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:qapp/model/Recitersmodel.dart';
// import 'package:qapp/model/surah_nameAr.dart';

// class SurahReciterAudioPage extends StatefulWidget {
//   final Moshaf moshaf;
//   final Reciter reciter;
//   final int initialSurahIndex;

//   const SurahReciterAudioPage({
//     super.key,
//     required this.moshaf,
//     required this.reciter,
//     required this.initialSurahIndex,
//   });

//   @override
//   State<SurahReciterAudioPage> createState() => _SurahReciterAudioPageState();
// }

// class _SurahReciterAudioPageState extends State<SurahReciterAudioPage> {
//   late AudioPlayer _player;
//   StreamSubscription? _stateSub;
//   StreamSubscription? _durationSub;
//   StreamSubscription? _positionSub;

//   late int currentIndex;

//   bool isPlaying = false;
//   Duration duration = Duration.zero;
//   Duration position = Duration.zero;

//   @override
//   void initState() {
//     super.initState();

//     _player = AudioPlayer();
//     currentIndex = widget.initialSurahIndex;

//     /// Listener State
//     _stateSub = _player.onPlayerStateChanged.listen((state) {
//       if (!mounted) return;
//       setState(() {
//         isPlaying = state == PlayerState.playing;
//       });
//     });

//     /// Listener Duration
//     _durationSub = _player.onDurationChanged.listen((d) {
//       if (!mounted) return;
//       setState(() => duration = d);
//     });

//     /// Listener Position
//     _positionSub = _player.onPositionChanged.listen((p) {
//       if (!mounted) return;
//       setState(() => position = p);
//     });

//     playCurrent();
//   }

//   Future<void> playCurrent() async {
//     final surahNum = widget.moshaf.surahList[currentIndex];
//     final url =
//         "${widget.moshaf.server}/${surahNum.toString().padLeft(3, '0')}.mp3";

//     await _player.stop();
//     await _player.play(UrlSource(url));
//   }

//   Future<void> next() async {
//     if (currentIndex < widget.moshaf.surahList.length - 1) {
//       currentIndex++;
//       await playCurrent();
//       if (mounted) setState(() {});
//     }
//   }

//   Future<void> previous() async {
//     if (currentIndex > 0) {
//       currentIndex--;
//       await playCurrent();
//       if (mounted) setState(() {});
//     }
//   }

//   @override
//   void dispose() {
//     /// توقف كل شيء قبل الإغلاق
//     _stateSub?.cancel();
//     _durationSub?.cancel();
//     _positionSub?.cancel();

//     _player.stop();
//     _player.dispose();

//     super.dispose();
//   }

//   String twoDigits(int n) => n.toString().padLeft(2, '0');

//   String format(Duration d) {
//     final m = twoDigits(d.inMinutes);
//     final s = twoDigits(d.inSeconds % 60);
//     return "$m:$s";
//   }

//   @override
//   Widget build(BuildContext context) {
//     final surahNum = widget.moshaf.surahList[currentIndex];
//     final surahName = arabicSuraNames[surahNum - 1];

//     return Scaffold(
//       appBar: AppBar(title: Text("سورة $surahName"), centerTitle: true),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             const SizedBox(height: 20),

//             Text(
//               "سورة $surahName",
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.purple,
//               ),
//             ),

//             const SizedBox(height: 30),

//             Slider(
//               value: position.inSeconds.toDouble().clamp(
//                 0,
//                 duration.inSeconds + 0.0,
//               ),
//               min: 0,
//               max: duration.inSeconds.toDouble() + 1,
//               onChanged: (v) {
//                 _player.seek(Duration(seconds: v.toInt()));
//               },
//               activeColor: Colors.purple,
//             ),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [Text(format(position)), Text(format(duration))],
//             ),

//             const SizedBox(height: 30),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 IconButton(
//                   icon: const Icon(
//                     Icons.skip_previous,
//                     size: 40,
//                     color: Colors.purple,
//                   ),
//                   onPressed: previous,
//                 ),
//                 IconButton(
//                   icon: Icon(
//                     isPlaying ? Icons.pause_circle : Icons.play_circle,
//                     size: 70,
//                     color: Colors.purple,
//                   ),
//                   onPressed: () {
//                     isPlaying ? _player.pause() : _player.resume();
//                   },
//                 ),
//                 IconButton(
//                   icon: const Icon(
//                     Icons.skip_next,
//                     size: 40,
//                     color: Colors.purple,
//                   ),
//                   onPressed: next,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:qapp/model/Recitersmodel.dart';
import 'package:qapp/model/surah_nameAr.dart';

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

  late int currentIndex;

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

    playCurrent();
  }

  Future<void> playCurrent() async {
    final surahNum = widget.moshaf.surahList[currentIndex];
    final url =
        "${widget.moshaf.server}/${surahNum.toString().padLeft(3, '0')}.mp3";

    await _player.stop();
    await _player.play(UrlSource(url));
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

    _player.stop();
    _player.dispose();
    super.dispose();
  }

  String fmt(Duration d) =>
      "${d.inMinutes.toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) {
    final surahNum = widget.moshaf.surahList[currentIndex];
    final surahName = arabicSuraNames[surahNum - 1];

    return Scaffold(
      appBar: AppBar(title: Text("سورة $surahName"), centerTitle: true),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.purple.shade50,
              Colors.white,
              Colors.purple.shade50,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // زخرفة علوية
              Image.asset(
                "assets/images/islamic_pattern.png",
                width: 130,
                height: 130,
                opacity: const AlwaysStoppedAnimation(.35),
              ),

              const SizedBox(height: 10),

              // إطار زخرفي
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 28,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.purple.shade300, width: 2),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  "سورة $surahName ",

                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple.shade700,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                " ${widget.reciter.name}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple.shade400,
                ),
              ),

              const SizedBox(height: 40),

              // شريط التقدم
              Slider(
                value: position.inSeconds.toDouble().clamp(
                  0,
                  duration.inSeconds + 0.0,
                ),
                min: 0,
                max: duration.inSeconds.toDouble() + 1,
                activeColor: Colors.purple,
                onChanged: (v) {
                  _player.seek(Duration(seconds: v.toInt()));
                },
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      fmt(position),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      fmt(duration),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // أزرار التشغيل
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 42,
                    color: Colors.purple.shade700,
                    icon: const Icon(Icons.skip_previous),
                    onPressed: previous,
                  ),

                  const SizedBox(width: 25),

                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.purple.shade300,
                    child: IconButton(
                      iconSize: 48,
                      color: Colors.white,
                      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                      onPressed: () {
                        isPlaying ? _player.pause() : _player.resume();
                      },
                    ),
                  ),

                  const SizedBox(width: 25),

                  IconButton(
                    iconSize: 42,
                    color: Colors.purple.shade700,
                    icon: const Icon(Icons.skip_next),
                    onPressed: next,
                  ),
                ],
              ),

              const SizedBox(height: 50),

              // زخرفة سفلية
              Image.asset(
                "assets/images/islamic_pattern.png",
                width: 150,
                height: 150,
                opacity: const AlwaysStoppedAnimation(.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
