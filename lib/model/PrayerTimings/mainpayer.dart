class PrayerResponse {
  final PrayerData data;

  PrayerResponse({required this.data});

  factory PrayerResponse.fromJson(Map<String, dynamic> json) {
    return PrayerResponse(data: PrayerData.fromJson(json["data"]));
  }
}

class PrayerCalendarResponse {
  final List<PrayerData> data;

  PrayerCalendarResponse({required this.data});

  factory PrayerCalendarResponse.fromJson(Map<String, dynamic> json) {
    return PrayerCalendarResponse(
      data: (json["data"] as List).map((e) => PrayerData.fromJson(e)).toList(),
    );
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
  final int year;
  final int month;
  final int day;

  PrayerDate({
    required this.readable,
    required this.year,
    required this.month,
    required this.day,
  });

  factory PrayerDate.fromJson(Map<String, dynamic> json) {
    final gregorian = json["gregorian"];
    int d = 1;
    int m = 1;
    int y = 2024;

    if (gregorian != null) {
      if (gregorian["day"] is String) {
        d = int.tryParse(gregorian["day"]) ?? 1;
      } else if (gregorian["day"] is int) {
        d = gregorian["day"];
      }

      if (gregorian["year"] is String) {
        y = int.tryParse(gregorian["year"]) ?? 2024;
      } else if (gregorian["year"] is int) {
        y = gregorian["year"];
      }

      final monthObj = gregorian["month"];
      if (monthObj != null) {
        if (monthObj["number"] is int) {
          m = monthObj["number"];
        }
      }
    }

    return PrayerDate(
      readable: json["readable"] ?? "",
      year: y,
      month: m,
      day: d,
    );
  }
}
