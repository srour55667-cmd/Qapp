class TafsirModel {
  final int id;
  final int sura;
  final int aya;
  final String arabicText;
  final String translation;

  TafsirModel({
    required this.id,
    required this.sura,
    required this.aya,
    required this.arabicText,
    required this.translation,
  });

  factory TafsirModel.fromJson(Map<String, dynamic> json) {
    return TafsirModel(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      sura: json['sura'] is String ? int.parse(json['sura']) : json['sura'],
      aya: json['aya'] is String ? int.parse(json['aya']) : json['aya'],
      arabicText: json['arabic_text'] ?? "",
      translation: json['translation'] ?? "",
    );
  }
}
