import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qapp/data/cubit/state_cubit.dart';
import 'package:qapp/model/PrayerTimings/mainpayer.dart';
import 'package:qapp/model/PrayerTimings/payerservices.dart';

import 'package:qapp/model/Recitersmodel.dart';
import 'package:qapp/model/TafsirModel.dart';
import 'package:qapp/model/TafsirService.dart';
import 'package:qapp/model/radio_model.dart';
import 'package:qapp/model/surah_model.dart';
import 'package:qapp/services/notificationservices/notification_service.dart';

class HomeCubit extends Cubit<Homestate> {
  HomeCubit() : super(Initialstate());

  final Dio dio = Dio();
  final PrayerService prayerService = PrayerService();

  /// ================================
  /// GET SUWAR
  /// ================================
  Future<List<SurahModel>> getSuwar() async {
    emit(LoadingState());
    try {
      final response = await dio.get(
        "https://www.mp3quran.net/api/v3/suwar?language=ar",
      );

      final data = response.data['suwar'] as List;
      final surahs = data.map((e) => SurahModel.fromJson(e)).toList();

      emit(SrahSuccessState(surahList: surahs));
      return surahs;
    } catch (e) {
      emit(ErrorState(errorMessage: e.toString()));
      return [];
    }
  }

  /// ================================
  /// GET RADIOS
  /// ================================
  Future<List<RadioModel>> getRadios() async {
    emit(LoadingState());

    try {
      final response = await dio.get(
        "https://www.mp3quran.net/api/v3/radios?language=ar",
      );

      final data = response.data['radios'] as List;

      final List<int> numid = [3, 32, 52, 58, 63, 68, 69];

      final radios = data
          .where((e) => numid.contains(e['id']))
          .map((e) => RadioModel.fromJson(e))
          .toList();

      emit(RadioSuccessState(radiosList: radios));
      return radios;
    } catch (e) {
      emit(ErrorState(errorMessage: e.toString()));
      return [];
    }
  }

  /// ================================
  /// GET RECITERS
  /// ================================
  Future<List<Reciter>> getReciters() async {
    emit(LoadingState());

    try {
      final response = await dio.get(
        "https://www.mp3quran.net/api/v3/reciters?language=ar",
      );

      final List data = response.data['reciters'];

      final List<int> ids = [
        81,
        82,
        92,
        111,
        112,
        118,
        5,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        35,
        102,
        123,
        241,
        121,
        243,
        253,
        265,
      ];

      final reciters = data
          .where((e) => ids.contains(e['id']))
          .map((e) => Reciter.fromJson(e))
          .toList();

      emit(RecitersSuccessState(reciters: reciters));
      return reciters;
    } catch (e) {
      emit(ErrorState(errorMessage: e.toString()));
      return [];
    }
  }

  /// ================================
  /// GET TAFSIR
  Future<List<TafsirModel>> getTafsir(int surahNumber) async {
    emit(LoadingState());
    try {
      final tafsir = await TafsirService().getTafsir(surahNumber);
      emit(TafsirSuccessState(tafsirList: tafsir));
      return tafsir;
    } catch (e) {
      emit(ErrorState(errorMessage: e.toString()));
      return [];
    }
  }

  /// ================================
  Future<PrayerData?> getPrayerTimes(String city) async {
    emit(PrayerLoadingState());

    try {
      final data = await prayerService.getPrayerTimesByCity(
        city: city,
        country: "Egypt",
      );

      emit(PrayerSuccessState(data: data));

      // --------------------------
      //  إضافة جدولة الصلاة هنا
      // --------------------------
      final timings = data.timings;

      final fajr = NotificationService.parsePrayerTime(timings.fajr);
      final dhuhr = NotificationService.parsePrayerTime(timings.dhuhr);
      final asr = NotificationService.parsePrayerTime(timings.asr);
      final maghrib = NotificationService.parsePrayerTime(timings.maghrib);
      final isha = NotificationService.parsePrayerTime(timings.isha);

      NotificationService.schedulePrayer(1, "الفجر", fajr);
      NotificationService.schedulePrayer(2, "الظهر", dhuhr);
      NotificationService.schedulePrayer(3, "العصر", asr);
      NotificationService.schedulePrayer(4, "المغرب", maghrib);
      NotificationService.schedulePrayer(5, "العشاء", isha);

      return data;
    } catch (e) {
      emit(PrayerErrorState(message: e.toString()));
      return null;
    }
  }
}
