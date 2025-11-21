import 'dart:collection';
import 'package:dio/dio.dart';

final dio = Dio();

/// بيرجع قائمة مرتبة وفريدة لروابط صفحات SVG الخاصة بالسورة.
/// احنا بناخد "page" فقط ونرمي باقي الداتا.
Future<List<String>> getSurahSvgPagesDio(int surahId, {int readId = 5}) async {
  final url = 'https://mp3quran.net/api/v3/ayat_timing';
  try {
    final res = await dio.get(
      url,
      queryParameters: {'surah': surahId, 'read': readId},
    );

    // الـ API بيرجع List<Map>
    final data = res.data as List;

    // نحافظ على الترتيب ونشيل التكرار
    final seen = LinkedHashSet<String>();
    for (final item in data) {
      final page = (item['page'] as String?)?.trim();
      if (page != null && page.isNotEmpty) {
        seen.add(page);
      }
    }

    // لو مفيش صفحات راجعة لأي سبب، نعمل fallback لصفحة واحدة حسب رقم السورة
    // if (seen.isEmpty) {
    //   final code = surahId.toString().padLeft(3, '0');
    //   seen.add('https://www.mp3quran.net/api/quran_pages_svg/$code.svg');
    // }

    return seen.toList();
  } on DioException catch (e) {
    // معالجة أخطاء الشبكة
    final msg =
        e.response != null
            ? 'فشل الجلب: ${e.response?.statusCode}'
            : 'مشكلة اتصال: ${e.message}';
    throw Exception(msg);
  } catch (e) {
    throw Exception('خطأ غير متوقع: $e');
  }
}
