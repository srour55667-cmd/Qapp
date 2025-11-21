class RadioModel {
  final int id;
  final String name;
  final String url;
  final String? date;

  RadioModel({
    required this.id,
    required this.name,
    required this.url,
    required this.date,
  });

  factory RadioModel.fromJson(Map<String, dynamic> json) {
    return RadioModel(
      name: json['name'],
      url: json['url'],
      id: json['id'],
      date: json['date'],
    );
  }
}
