import 'package:shared_preferences/shared_preferences.dart';

/// Service to persist and retrieve last read position
class LastReadService {
  static const String _keySurahId = 'last_read_surah_id';
  static const String _keyScrollOffset = 'last_read_scroll_offset';

  /// Save the current reading position
  static Future<void> savePosition(int surahId, double scrollOffset) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keySurahId, surahId);
    await prefs.setDouble(_keyScrollOffset, scrollOffset);
  }

  /// Get the last read surah ID, returns null if none saved
  static Future<int?> getLastSurahId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keySurahId);
  }

  /// Get the last scroll offset, returns 0.0 if none saved
  static Future<double> getLastScrollOffset() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_keyScrollOffset) ?? 0.0;
  }

  /// Clear saved position
  static Future<void> clearPosition() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keySurahId);
    await prefs.remove(_keyScrollOffset);
  }
}
