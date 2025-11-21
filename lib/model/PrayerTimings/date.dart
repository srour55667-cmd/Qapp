class HijriDate {
  final String date;
  final String weekdayAr;

  HijriDate({required this.date, required this.weekdayAr});

  factory HijriDate.fromJson(Map<String, dynamic> json) {
    return HijriDate(
      date: json['date'] ?? '',
      weekdayAr: json['weekday']?['ar'] ?? '',
    );
  }
}
