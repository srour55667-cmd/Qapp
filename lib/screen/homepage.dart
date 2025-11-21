import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qapp/data/cubit/home_cubit.dart';
import 'package:qapp/screen/azkar/AzkarCategoriesPage.dart';
import 'package:qapp/screen/prayer/prayer_page.dart';
import 'package:qapp/screen/sipha/tasbeeh_page.dart';
import 'package:qapp/screen/surah/suwar_page.dart';
import 'package:qapp/screen/radio/radio_page.dart';
import 'package:qapp/screen/recites/recites_page.dart';
import 'package:qapp/screen/tafseer/TafsirCategoriesPage.dart';
import 'package:qapp/widget/feature_card.dart';
import 'package:qapp/widget/timeandtext.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // ========= Banner ========
              SizedBox(
                width: double.infinity,
                height: 205,
                child: Stack(
                  children: [
                    Positioned(
                      right: 8,
                      child: SizedBox(
                        width: 170,
                        height: 200,
                        child: Image.asset(
                          "assets/images/image4.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const Positioned(
                      left: 2,
                      top: 40,
                      child: Timeandtext(text: "اقرأ القرآن بسهولة"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "الأقسام",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple.shade700,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// ***************
              ///  GRIDVIEW scrollable
              /// ***************
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 0.9,
                children: [
                  FeatureCard(
                    title: 'السور',
                    icon: Icons.menu_book,
                    iconColor: Colors.purple,
                    circleColor: Colors.purple.shade50,
                    onTap: () async {
                      final suwar = await cubit.getSuwar();
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SuwarPage(surahs: suwar),
                          ),
                        );
                      }
                    },
                  ),

                  FeatureCard(
                    title: 'الإذاعات',
                    icon: Icons.radio,
                    iconColor: Colors.purple,
                    circleColor: Colors.purple.shade50,
                    onTap: () async {
                      final radios = await cubit.getRadios();
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RadiosPage(radios: radios),
                          ),
                        );
                      }
                    },
                  ),

                  FeatureCard(
                    title: 'القراء',
                    icon: Icons.record_voice_over,
                    iconColor: Colors.purple,
                    circleColor: Colors.purple.shade50,
                    onTap: () async {
                      final reciters = await cubit.getReciters();
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RecitersPage(reciters: reciters),
                          ),
                        );
                      }
                    },
                  ),

                  FeatureCard(
                    title: "الأذكار",
                    icon: Icons.menu_book,
                    iconColor: Colors.purple,
                    circleColor: Colors.purple.shade50,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AzkarCategoriesPage(),
                        ),
                      );
                    },
                  ),

                  FeatureCard(
                    title: 'السبحة',
                    icon: Icons.brightness_5,
                    iconColor: Colors.purple,
                    circleColor: Colors.purple.shade50,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SebhaPage(),
                        ),
                      );
                    },
                  ),
                  FeatureCard(
                    title: 'مواقيت الصلاة',
                    icon: Icons.access_time_filled,
                    iconColor: Colors.purple,
                    circleColor: Colors.purple.shade50,
                    onTap: () async {
                      final data = await cubit.getPrayerTimes("Cairo");
                      if (data != null && context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => PrayerTimesPage()),
                        );
                      }
                    },
                  ),
                  FeatureCard(
                    title: 'التفسير',
                    icon: Icons.menu_book_outlined,
                    iconColor: Colors.purple,
                    circleColor: Colors.purple.shade50,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TafsirCategoriesPage(),
                        ),
                      );
                    },
                  ),

                  FeatureCard(
                    title: 'المفضلة',
                    icon: Icons.star,
                    iconColor: Colors.purple,
                    circleColor: Colors.purple.shade50,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
