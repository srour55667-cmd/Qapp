import 'package:flutter/material.dart';
import 'package:qapp/model/surah_model.dart';
import 'package:qapp/model/suwer_nameEng_model.dart';
import 'package:qapp/widget/surah_viwers.dart';

class listview_category_suwar extends StatelessWidget {
  const listview_category_suwar({super.key, required this.surahList});

  final List<SurahModel> surahList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: surahList.length,
      itemBuilder: (context, index) {
        final surah = surahList[index];
        return categoryItem(
          numSurah: surah.id,
          surahNameEng: Name_Eng[index],
          surahNameArb: surah.nameAr,
          surahType: surah.type == 1 ? "مكية" : "مدنية",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SurahImagesView(surahId: surah.id, surahName: surah.nameAr),
              ),
            );
          },
        );
      },
    );
  }

  Widget categoryItem({
    required int numSurah,
    required String surahNameEng,
    required String surahNameArb,
    required String surahType,
    required void Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 70,
              decoration: const BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ListTile(
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.purple),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$numSurah',
                    style: const TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  surahNameEng,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Text(
                  surahType,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                trailing: Text(
                  surahNameArb,
                  style: const TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
