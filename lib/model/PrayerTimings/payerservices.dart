import 'package:dio/dio.dart';
import 'package:qapp/model/PrayerTimings/mainpayer.dart';

class PrayerService {
  final Dio dio = Dio();

  Future<PrayerData> getPrayerTimesByCity({
    required String city,
    required String country,
  }) async {
    final response = await dio.get(
      "https://api.aladhan.com/v1/timingsByCity",
      queryParameters: {"city": city, "country": country, "method": 8},
    );

    final prayerResponse = PrayerResponse.fromJson(response.data);
    return prayerResponse.data;
  }
}
