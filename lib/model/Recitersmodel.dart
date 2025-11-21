class RecitersResponse {
  final List<Reciter> reciters;

  RecitersResponse({required this.reciters});

  factory RecitersResponse.fromJson(Map<String, dynamic> json) {
    return RecitersResponse(
      reciters: (json['reciters'] as List)
          .map((e) => Reciter.fromJson(e))
          .toList(),
    );
  }
}

class Reciter {
  final int id;
  final String name;
  final String? letter;
  final String? date;
  final List<Moshaf> moshaf;

  Reciter({
    required this.id,
    required this.name,
    this.letter,
    this.date,
    required this.moshaf,
  });

  factory Reciter.fromJson(Map<String, dynamic> json) {
    return Reciter(
      id: json['id'],
      name: json['name'] ?? '',
      letter: json['letter'],
      date: json['date'],
      moshaf: (json['moshaf'] as List).map((e) => Moshaf.fromJson(e)).toList(),
    );
  }
}

class Moshaf {
  final int id;
  final String name;
  final String server;
  final int surahTotal;
  final int moshafType;
  final List<int> surahList;

  Moshaf({
    required this.id,
    required this.name,
    required this.server,
    required this.surahTotal,
    required this.moshafType,
    required this.surahList,
  });

  factory Moshaf.fromJson(Map<String, dynamic> json) {
    return Moshaf(
      id: json['id'],
      name: json['name'] ?? '',
      server: json['server'] ?? '',
      surahTotal: json['surah_total'] ?? 0,
      moshafType: json['moshaf_type'] ?? 0,
      surahList: (json['surah_list'] as String)
          .split(',')
          .map((e) => int.parse(e.trim()))
          .toList(),
    );
  }
}
