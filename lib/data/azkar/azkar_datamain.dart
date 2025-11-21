import 'package:qapp/data/azkar/azkar_data.dart';
import 'package:qapp/data/azkar/azkerevent.dart';
import 'package:qapp/data/azkar/azkermorning.dart';
import 'package:qapp/data/azkar/azkerprophets.dart';
import 'package:qapp/data/azkar/azkerquran.dart';
import 'package:qapp/data/azkar/azkersleep.dart';
import 'package:qapp/data/azkar/azkerwakup.dart';

// الملف الرئيسي
final Map<String, List<AzkarItem>> azkarData = {
  "أذكار الصباح": azkarMorning,
  "أذكار المساء": azkarEvening,
  "أذكار النوم": azkarSleep,
  "أذكار الاستيقاظ": azkarWakeup,
  "أدعية قرآنية": azkarQuran,
  "أدعية الأنبياء": azkarProphets,
};
