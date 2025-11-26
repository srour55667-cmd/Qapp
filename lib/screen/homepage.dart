import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qapp/data/cubit/home_cubit.dart';

// الصفحات
import 'package:qapp/screen/azkar/AzkarCategoriesPage.dart';
import 'package:qapp/screen/prayer/prayer_page.dart';
import 'package:qapp/screen/settingpage/setting.dart';
import 'package:qapp/screen/sipha/tasbeeh_page.dart';

import 'package:qapp/screen/surah/suwar_page.dart';
import 'package:qapp/screen/radio/radio_page.dart';
import 'package:qapp/screen/recites/recites_page.dart';
import 'package:qapp/screen/tafseer/TafsirCategoriesPage.dart';

// ودجت
import 'package:qapp/widget/timeandtext.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text("الرئيسية"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===============================
            //         HEADER BANNER
            // ===============================
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primary.withOpacity(0.15),
                    primary.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Image.asset(
                      "assets/images/image4.png",
                      width: 180,
                      height: 180,
                      fit: BoxFit.contain,
                      opacity: const AlwaysStoppedAnimation(.85),
                    ),
                  ),
                  const Positioned(
                    left: 16,
                    top: 40,
                    child: Timeandtext(text: "منصة إسلامية شاملة للمسلمين"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ===============================
            //         TITLE
            // ===============================
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "الأقسام",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ===============================
            //         GRID ITEMS
            // ===============================
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 18,
                childAspectRatio: 0.90,
              ),
              children: [
                _buildItem(
                  context,
                  title: 'السور',
                  icon: Icons.menu_book_rounded,
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

                _buildItem(
                  context,
                  title: 'الإذاعات',
                  icon: Icons.radio_rounded,
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

                _buildItem(
                  context,
                  title: 'القراء',
                  icon: Icons.record_voice_over_rounded,
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

                _buildItem(
                  context,
                  title: "الأذكار",
                  icon: Icons.auto_awesome_rounded,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AzkarCategoriesPage(),
                      ),
                    );
                  },
                ),

                _buildItem(
                  context,
                  title: 'السبحة',
                  icon: Icons.brightness_5_rounded,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SebhaPage()),
                    );
                  },
                ),

                _buildItem(
                  context,
                  title: 'مواقيت الصلاة',
                  icon: Icons.access_time_filled_rounded,
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

                _buildItem(
                  context,
                  title: 'التفسير',
                  icon: Icons.menu_book_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TafsirCategoriesPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ===============================
  //          GRID ITEM
  // ===============================
  Widget _buildItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final primary = Theme.of(context).colorScheme.primary;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: primary.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 34,
              backgroundColor: primary.withOpacity(0.15),
              child: Icon(icon, color: primary, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
