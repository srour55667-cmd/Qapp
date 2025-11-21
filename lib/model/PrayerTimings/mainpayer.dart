class PrayerResponse {
  final PrayerData data;

  PrayerResponse({required this.data});

  factory PrayerResponse.fromJson(Map<String, dynamic> json) {
    return PrayerResponse(data: PrayerData.fromJson(json["data"]));
  }
}

class PrayerData {
  final PrayerTimings timings;
  final PrayerDate date;

  PrayerData({required this.timings, required this.date});

  factory PrayerData.fromJson(Map<String, dynamic> json) {
    return PrayerData(
      timings: PrayerTimings.fromJson(json["timings"]),
      date: PrayerDate.fromJson(json["date"]),
    );
  }
}

class PrayerTimings {
  final String fajr;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;

  PrayerTimings({
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  factory PrayerTimings.fromJson(Map<String, dynamic> json) {
    return PrayerTimings(
      fajr: json["Fajr"] ?? "",
      dhuhr: json["Dhuhr"] ?? "",
      asr: json["Asr"] ?? "",
      maghrib: json["Maghrib"] ?? "",
      isha: json["Isha"] ?? "",
    );
  }
}

class PrayerDate {
  final String readable;

  PrayerDate({required this.readable});

  factory PrayerDate.fromJson(Map<String, dynamic> json) {
    return PrayerDate(readable: json["readable"] ?? "");
  }
}
