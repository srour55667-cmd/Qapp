import 'package:dio/dio.dart';
import 'package:qapp/model/TafsirModel.dart';

class TafsirService {
  final Dio dio = Dio();

  Future<List<TafsirModel>> getTafsir(int surahNumber) async {
    final response = await dio.get(
      "https://quranenc.com/api/v1/translation/sura/arabic_moyassar/$surahNumber",
    );

    final List data = response.data['result'];

    return data.map((e) => TafsirModel.fromJson(e)).toList();
  }
}
