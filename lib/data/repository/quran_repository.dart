import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:quran/quran.dart' as quran;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qapp/model/surah_model.dart';
import 'dart:async';

class QuranRepository {
  static Database? _database;
  static const String _dbName = 'quran_v1.db';
  static const String _isReadyKey = 'is_quran_data_ready';

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE surahs (
            id INTEGER PRIMARY KEY,
            name_ar TEXT,
            type INTEGER,
            verses_count INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE verses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            surah_id INTEGER,
            verse_number INTEGER,
            text TEXT,
            FOREIGN KEY (surah_id) REFERENCES surahs (id)
          )
        ''');
      },
    );
  }

  static Future<bool> isQuranDataReady() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isReadyKey) ?? false;
  }

  static Future<void> initQuranData({Function(double)? onProgress}) async {
    final db = await database;
    final isReady = await isQuranDataReady();
    if (isReady) return;

    await db.transaction((txn) async {
      for (int i = 1; i <= 114; i++) {
        final nameAr = quran.getSurahNameArabic(i);
        final versesCount = quran.getVerseCount(i);
        final place = quran.getPlaceOfRevelation(i);
        final type = (place == 'Makkah') ? 1 : 2;

        await txn.insert('surahs', {
          'id': i,
          'name_ar': nameAr,
          'type': type,
          'verses_count': versesCount,
        });

        for (int v = 1; v <= versesCount; v++) {
          await txn.insert('verses', {
            'surah_id': i,
            'verse_number': v,
            'text': quran.getVerse(i, v, verseEndSymbol: true),
          });
        }

        if (onProgress != null) {
          onProgress(i / 114);
        }
      }
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isReadyKey, true);
  }

  static Future<List<SurahModel>> getSurahList() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'surahs',
      orderBy: 'id ASC',
    );

    return maps
        .map(
          (m) => SurahModel(id: m['id'], nameAr: m['name_ar'], type: m['type']),
        )
        .toList();
  }

  static Future<List<String>> getSurahAyat(int surahNumber) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'verses',
      where: 'surah_id = ?',
      whereArgs: [surahNumber],
      orderBy: 'verse_number ASC',
    );

    return maps.map((m) => m['text'] as String).toList();
  }
}
