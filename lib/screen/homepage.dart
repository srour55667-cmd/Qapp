import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qapp/core/theme/app_colors.dart';
import 'package:qapp/core/widgets/custom_app_bar.dart';
import 'package:qapp/core/widgets/surah_tile.dart';
import 'package:qapp/data/cubit/home_cubit.dart';
import 'package:qapp/model/surah_model.dart';
import 'package:qapp/screen/azkar/AzkarCategoriesPage.dart';
import 'package:qapp/screen/prayer/prayer_page.dart';
import 'package:qapp/screen/radio/radio_page.dart';
import 'package:qapp/screen/recites/recites_page.dart';
import 'package:qapp/screen/settingpage/setting.dart';
import 'package:qapp/screen/sipha/tasbeeh_page.dart';
import 'package:qapp/screen/tafseer/tafsir_categories_page.dart';
import 'package:qapp/screen/surah/surah_text_page.dart';

import 'package:qapp/model/suwer_nameEng_model.dart';
import 'package:qapp/model/PrayerTimings/mainpayer.dart';
import 'package:qapp/screen/dashboard/next_prayer_card.dart';
import 'package:qapp/core/theme/app_spacing.dart';
import 'package:qapp/data/cubit/reading_progress_cubit.dart';
import 'package:qapp/data/cubit/reading_progress_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // Cache for Suwar list
  List<SurahModel>? _suwarList;
  PrayerData? _prayerData;

  @override
  void initState() {
    super.initState();
    _loadSuwar();
    _loadPrayerTimes();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadSuwar() async {
    final cubit = context.read<HomeCubit>();
    final list = await cubit.getSuwar();
    if (mounted) {
      setState(() => _suwarList = list);
      // Notify reading progress cubit to resolve names
      if (mounted) {
        context.read<ReadingProgressCubit>().updateSuwarList(list);
      }
    }
  }

  Future<void> _loadPrayerTimes() async {
    final cubit = context.read<HomeCubit>();
    final data = await cubit.getPrayerTimes("Cairo");
    if (mounted && data != null) {
      setState(() => _prayerData = data);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildQuranTab(context),
          _buildDashboardTab(context),
          const SettingsPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;

            // Exit search mode when changing tabs
          });
        },
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        indicatorColor: AppColors.primary.withOpacity(0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book, color: AppColors.primary),
            label: 'القرآن',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view),
            selectedIcon: Icon(
              Icons.grid_view_rounded,
              color: AppColors.primary,
            ),
            label: 'الخدمات',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings, color: AppColors.primary),
            label: 'الإعدادات',
          ),
        ],
      ),
    );
  }

  Widget _buildQuranTab(BuildContext context) {
    if (_suwarList == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return CustomScrollView(
      slivers: [
        const CustomSliverAppBar(title: Text("القرآن الكريم")),
        // Resume Reading / Start Reading Card (Reactive with BlocBuilder)
        BlocBuilder<ReadingProgressCubit, ReadingProgressState>(
          builder: (context, state) {
            // Determine display values based on state
            final bool hasProgress = state is ReadingProgressLoaded;
            final int surahId = hasProgress ? state.surahId : 1;
            final int ayahNumber = hasProgress ? state.ayahNumber : 0;
            final String surahName = hasProgress ? state.surahName : 'الفاتحة';
            final String buttonText = hasProgress ? 'رجوع' : 'ابدأ';
            final IconData icon = hasProgress
                ? Icons.bookmark
                : Icons.play_arrow;

            String subtitle = 'لا يوجد آخر توقف بعد';
            if (hasProgress) {
              if (ayahNumber > 0) {
                subtitle = 'آخر توقف: $surahName (الآية $ayahNumber)';
              } else {
                subtitle = 'آخر توقف: $surahName';
              }
            }

            return SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  AppSpacing.sm, // Reduced from md
                  AppSpacing.screenPadding,
                  AppSpacing.md,
                ),
                child: Material(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SurahTextPage(
                            surahId: surahId,
                            surahName: surahName,
                            initialAyahNumber: ayahNumber,
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(icon, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'متابعة القراءة',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  subtitle,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusSm,
                              ),
                            ),
                            child: Text(
                              buttonText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        SliverPadding(
          padding: const EdgeInsets.only(bottom: AppSpacing.lg),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final surah = _suwarList![index];

              String enName = "";
              if ((surah.id - 1) < Name_Eng.length) {
                enName = Name_Eng[surah.id - 1];
              }

              return SurahTile(
                number: surah.id,
                nameAr: surah.nameAr,
                nameEn: enName,
                subtitle: surah.type == 1 ? "مكية" : "مدنية",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SurahTextPage(
                        surahId: surah.id,
                        surahName: surah.nameAr,
                      ),
                    ),
                  );
                },
              );
            }, childCount: _suwarList!.length),
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardTab(BuildContext context) {
    final cubit = context.read<HomeCubit>();

    return CustomScrollView(
      slivers: [
        const CustomSliverAppBar(title: Text("خدمات المسلم")),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_prayerData != null)
                  NextPrayerCard(timings: _prayerData!.timings),
                _buildFeatureGrid(context, cubit),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureGrid(BuildContext context, HomeCubit cubit) {
    final width = MediaQuery.of(context).size.width;
    // Responsive grid: 2 columns for phones, 3 or 4 for tablets
    final crossAxisCount = width > 900 ? 4 : (width > 600 ? 3 : 2);

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: AppSpacing.lg,
      mainAxisSpacing: AppSpacing.lg,
      childAspectRatio: 1.1,
      children: [
        _buildFeatureItem(
          context,
          "القراء",
          Icons.record_voice_over_rounded,
          () async {
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
          Colors.indigo,
        ),

        _buildFeatureItem(context, "الأذكار", Icons.auto_awesome_rounded, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AzkarCategoriesPage()),
          );
        }, Colors.purple),
        _buildFeatureItem(context, "السبحة", Icons.brightness_5_rounded, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SebhaPage()),
          );
        }, Colors.teal),
        _buildFeatureItem(context, "الإذاعات", Icons.radio_rounded, () async {
          final radios = await cubit.getRadios();
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => RadiosPage(radios: radios)),
            );
          }
        }, Colors.blue),

        _buildFeatureItem(context, "التفسير", Icons.menu_book_outlined, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TafsirCategoriesPage()),
          );
        }, Colors.brown),
        _buildFeatureItem(
          context,
          "مواقيت الصلاة",
          Icons.access_time_filled_rounded,
          () async {
            final data = await cubit.getPrayerTimes("Cairo");
            if (data != null && context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PrayerTimesPage()),
              );
            }
          },
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
