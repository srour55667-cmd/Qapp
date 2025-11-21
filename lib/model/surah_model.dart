class SurahModel {
  final int id;
  final String nameAr;
  final int type;

  SurahModel({required this.id, required this.nameAr, required this.type});

  factory SurahModel.fromJson(json) {
    return SurahModel(
      id: json['id'] ?? 0,
      nameAr: json['name'] ?? "name not found ",
      type: json['makkia'] ?? 1,
    );
  }
}
