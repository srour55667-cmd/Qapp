import 'package:dio/dio.dart';
import 'package:qapp/model/PrayerTimings/mainpayer.dart';

class PrayerService {
  final Dio dio = Dio();
  static bool debugMode = false;

  Future<PrayerData> getPrayerTimesByCity({
    required String city,
    required String country,
  }) async {
    if (debugMode) {
      return _getMockPrayerData();
    }
    final response = await dio.get(
      "https://api.aladhan.com/v1/timingsByCity",
      queryParameters: {"city": city, "country": country, "method": 8},
    );

    final prayerResponse = PrayerResponse.fromJson(response.data);
    return prayerResponse.data;
  }

  Future<List<PrayerData>> getPrayerCalendarByCity({
    required String city,
    required String country,
  }) async {
    if (debugMode) {
      return [_getMockPrayerData()];
    }
    final now = DateTime.now();
    final response = await dio.get(
      "https://api.aladhan.com/v1/calendarByCity",
      queryParameters: {
        "city": city,
        "country": country,
        "method": 8,
        "month": now.month,
        "year": now.year,
      },
    );

    final calendarResponse = PrayerCalendarResponse.fromJson(response.data);
    return calendarResponse.data;
  }

  PrayerData _getMockPrayerData() {
    final now = DateTime.now();
    return PrayerData(
      timings: PrayerTimings(
        fajr: _formatTime(now.add(const Duration(minutes: 1))),
        dhuhr: _formatTime(now.add(const Duration(minutes: 2))),
        asr: _formatTime(now.add(const Duration(minutes: 3))),
        maghrib: _formatTime(now.add(const Duration(minutes: 4))),
        isha: _formatTime(now.add(const Duration(minutes: 5))),
      ),
      date: PrayerDate(
        readable: "Mock Date",
        year: now.year,
        month: now.month,
        day: now.day,
      ),
    );
  }

  String _formatTime(DateTime dt) {
    return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }
}
