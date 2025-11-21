import 'package:flutter/material.dart';
import 'package:qapp/model/surah_model.dart';
import 'package:qapp/screen/surah/listview_category_suwar.dart';

class SuwarPage extends StatelessWidget {
  final List<SurahModel> surahs;

  const SuwarPage({super.key, required this.surahs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("السور"), centerTitle: true),
      body: listview_category_suwar(surahList: surahs),
    );
  }
}
