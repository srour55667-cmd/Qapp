import 'package:qapp/model/PrayerTimings/mainpayer.dart';
import 'package:qapp/model/Recitersmodel.dart';
import 'package:qapp/model/TafsirModel.dart';
import 'package:qapp/model/radio_model.dart';
import 'package:qapp/model/surah_model.dart';

abstract class Homestate {}

class Initialstate extends Homestate {}

class LoadingState extends Homestate {}

class ErrorState extends Homestate {
  final String errorMessage;
  ErrorState({required this.errorMessage});
}

class SrahSuccessState extends Homestate {
  final List<SurahModel> surahList;
  SrahSuccessState({required this.surahList});
}

class RadioSuccessState extends Homestate {
  final List<RadioModel> radiosList;
  RadioSuccessState({required this.radiosList});
}

class RecitersSuccessState extends Homestate {
  final List<Reciter> reciters;
  RecitersSuccessState({required this.reciters});
}

class PrayerLoadingState extends Homestate {}

class PrayerSuccessState extends Homestate {
  final PrayerData data;
  PrayerSuccessState({required this.data});
}

class PrayerErrorState extends Homestate {
  final String message;
  PrayerErrorState({required this.message});
}

class TafsirSuccessState extends Homestate {
  final List<TafsirModel> tafsirList;

  TafsirSuccessState({required this.tafsirList});
}
