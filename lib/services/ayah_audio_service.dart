import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Service to handle playing specific Ayah audio
/// URL pattern: https://everyayah.com/data/Alafasy_128kbps/{surah}{ayah}.mp3
class AyahAudioService {
  static final AyahAudioService _instance = AyahAudioService._internal();
  factory AyahAudioService() => _instance;

  AyahAudioService._internal();

  final AudioPlayer _player = AudioPlayer();

  // Current playback state
  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  // Callback for state changes
  Function(bool isPlaying)? onStateChanged;

  /// Play audio for specific Surah and Ayah
  Future<void> playAyah(int surahNumber, int ayahNumber) async {
    try {
      await stop(); // Stop any current audio

      final String surahStr = surahNumber.toString().padLeft(3, '0');
      final String ayahStr = ayahNumber.toString().padLeft(3, '0');
      final String url =
          'https://everyayah.com/data/Alafasy_128kbps/$surahStr$ayahStr.mp3';

      print('Playing Ayah: $url');

      await _player.play(UrlSource(url));
      _isPlaying = true;
      onStateChanged?.call(true);

      _player.onPlayerComplete.listen((_) {
        _isPlaying = false;
        onStateChanged?.call(false);
      });
    } catch (e) {
      print('Error playing ayah audio: $e');
      _isPlaying = false;
      onStateChanged?.call(false);
    }
  }

  /// Pause audio
  Future<void> pause() async {
    await _player.pause();
    _isPlaying = false;
    onStateChanged?.call(false);
  }

  /// Resume audio
  Future<void> resume() async {
    await _player.resume();
    _isPlaying = true;
    onStateChanged?.call(true);
  }

  /// Stop audio
  Future<void> stop() async {
    await _player.stop();
    _isPlaying = false;
    onStateChanged?.call(false);
  }
}
