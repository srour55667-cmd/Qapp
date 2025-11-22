// import 'package:flutter/material.dart';
// import 'package:qapp/model/surah_model.dart';
// import 'package:qapp/model/suwer_nameEng_model.dart';
// import 'package:qapp/widget/surah_viwers.dart';

// class listview_category_suwar extends StatelessWidget {
//   const listview_category_suwar({super.key, required this.surahList});

//   final List<SurahModel> surahList;

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: surahList.length,
//       itemBuilder: (context, index) {
//         final surah = surahList[index];
//         return categoryItem(
//           numSurah: surah.id,
//           surahNameEng: Name_Eng[index],
//           surahNameArb: surah.nameAr,
//           surahType: surah.type == 1 ? "مكية" : "مدنية",
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) =>
//                     SurahImagesView(surahId: surah.id, surahName: surah.nameAr),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget categoryItem({
//     required int numSurah,
//     required String surahNameEng,
//     required String surahNameArb,
//     required String surahType,
//     required void Function()? onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 6,
//               offset: Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 4,
//               height: 70,
//               decoration: const BoxDecoration(
//                 color: Colors.purple,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(12),
//                   bottomLeft: Radius.circular(12),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8),
//             Expanded(
//               child: ListTile(
//                 leading: Container(
//                   width: 36,
//                   height: 36,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(color: Colors.purple),
//                   ),
//                   alignment: Alignment.center,
//                   child: Text(
//                     '$numSurah',
//                     style: const TextStyle(
//                       color: Colors.purple,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 title: Text(
//                   surahNameEng,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 subtitle: Text(
//                   surahType,
//                   style: const TextStyle(color: Colors.grey, fontSize: 12),
//                 ),
//                 trailing: Text(
//                   surahNameArb,
//                   style: const TextStyle(
//                     color: Colors.purple,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:qapp/model/surah_model.dart';
import 'package:qapp/model/suwer_nameEng_model.dart';
import 'package:qapp/widget/surah_viwers.dart';

class listview_category_suwar extends StatelessWidget {
  final List<SurahModel> surahList;

  const listview_category_suwar({super.key, required this.surahList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: surahList.length,
      padding: const EdgeInsets.only(top: 12, bottom: 20),
      itemBuilder: (context, index) {
        final surah = surahList[index];

        return _surahItem(
          context,
          index: index,
          numSurah: surah.id,
          surahNameEng: Name_Eng[index],
          surahNameArb: surah.nameAr,
          surahType: surah.type == 1 ? "مكية" : "مدنية",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    SurahImagesView(surahId: surah.id, surahName: surah.nameAr),
              ),
            );
          },
        );
      },
    );
  }

  Widget _surahItem(
    BuildContext context, {
    required int index,
    required int numSurah,
    required String surahNameEng,
    required String surahNameArb,
    required String surahType,
    required VoidCallback onTap,
  }) {
    final primary = Theme.of(context).colorScheme.primary;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return AnimatedContainer(
      duration: Duration(milliseconds: 400 + (index * 40)),
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: primary.withOpacity(0.10),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // الشريط الجانبي
              Container(
                width: 6,
                height: 70,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              const SizedBox(width: 12),

              // رقم السورة
              CircleAvatar(
                radius: 22,
                backgroundColor: primary.withOpacity(0.15),
                child: Text(
                  '$numSurah',
                  style: TextStyle(
                    color: primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // النصوص
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // اسم السورة بالعربي (Amiri)
                    Text(
                      surahNameArb,
                      style: TextStyle(
                        fontFamily: "Amiri",
                        fontSize: 22,
                        color: primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    // اسم السورة بالإنجليزي
                    Text(
                      surahNameEng,
                      style: TextStyle(
                        color: textColor.withOpacity(0.75),
                        fontSize: 14,
                      ),
                    ),

                    // نوع السورة
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: primary.withOpacity(0.8),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          surahType,
                          style: TextStyle(
                            color: primary.withOpacity(0.9),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
