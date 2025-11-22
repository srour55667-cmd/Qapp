// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:qapp/data/cubit/home_cubit.dart';
// import 'package:qapp/data/cubit/state_cubit.dart';
// import 'package:qapp/model/cityname_model.dart';

// class PrayerTimesPage extends StatefulWidget {
//   const PrayerTimesPage({super.key});

//   @override
//   State<PrayerTimesPage> createState() => _PrayerTimesPageState();
// }

// class _PrayerTimesPageState extends State<PrayerTimesPage> {
//   String selectedCityArabic = "القاهرة";

//   @override
//   void initState() {
//     super.initState();
//     final cubit = context.read<HomeCubit>();
//     cubit.getPrayerTimes(egyptCitiesMap[selectedCityArabic]!);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cubit = context.read<HomeCubit>();

//     return Scaffold(
//       backgroundColor: const Color(0xFF180B37),
//       appBar: AppBar(
//         title: const Text("مواقيت الصلاة"),
//         centerTitle: true,
//         backgroundColor: Colors.purple,
//       ),
//       body: Stack(
//         children: [
//           /// ======================
//           ///   BACKGROUND IMAGE
//           /// ======================
//           Positioned.fill(
//             child: Opacity(
//               opacity: 0.15,
//               child: Image.asset(
//                 "assets/images/Ptime.png", // << ضع هنا صورتك
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),

//           /// ======================
//           ///   MAIN CONTENT
//           /// ======================
//           Column(
//             children: [
//               const SizedBox(height: 20),

//               /// المحافظة
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   child: DropdownButton<String>(
//                     value: selectedCityArabic,
//                     isExpanded: true,
//                     underline: const SizedBox(),
//                     dropdownColor: Colors.white,
//                     items: egyptCitiesMap.keys.map((cityArabic) {
//                       return DropdownMenuItem(
//                         value: cityArabic,
//                         child: Text(
//                           cityArabic,
//                           style: const TextStyle(fontSize: 18),
//                         ),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         selectedCityArabic = value!;
//                       });
//                       cubit.getPrayerTimes(egyptCitiesMap[selectedCityArabic]!);
//                     },
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 50),

//               Expanded(
//                 child: BlocBuilder<HomeCubit, Homestate>(
//                   builder: (context, state) {
//                     if (state is PrayerLoadingState) {
//                       return const Center(
//                         child: CircularProgressIndicator(color: Colors.white),
//                       );
//                     }

//                     if (state is PrayerErrorState) {
//                       return Center(
//                         child: Text(
//                           "خطأ: ${state.message}",
//                           style: const TextStyle(
//                             color: Colors.red,
//                             fontSize: 18,
//                           ),
//                         ),
//                       );
//                     }

//                     if (state is PrayerSuccessState) {
//                       final t = state.data.timings;

//                       return ListView(
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                         children: [
//                           const SizedBox(height: 10),
//                           PrayerCard("الفجر", t.fajr),
//                           PrayerCard("الظهر", t.dhuhr),
//                           PrayerCard("العصر", t.asr),
//                           PrayerCard("المغرب", t.maghrib),
//                           PrayerCard("العشاء", t.isha),
//                         ],
//                       );
//                     }

//                     return const SizedBox();
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class PrayerCard extends StatelessWidget {
//   final String name;
//   final String time;

//   const PrayerCard(this.name, this.time, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 14),
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.92),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             name,
//             style: const TextStyle(
//               color: Colors.black,
//               fontSize: 20,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           Text(
//             _convertTo12Hour(time),
//             style: const TextStyle(
//               color: Colors.purple,
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _convertTo12Hour(String time24) {
//     try {
//       final parts = time24.split(":");
//       int h = int.parse(parts[0]);
//       final m = parts[1];

//       final suffix = h >= 12 ? "PM" : "AM";
//       if (h > 12) h -= 12;
//       if (h == 0) h = 12;

//       return "$h:$m $suffix";
//     } catch (_) {
//       return time24;
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qapp/data/cubit/home_cubit.dart';
import 'package:qapp/data/cubit/state_cubit.dart';
import 'package:qapp/model/cityname_model.dart';

class PrayerTimesPage extends StatefulWidget {
  const PrayerTimesPage({super.key});

  @override
  State<PrayerTimesPage> createState() => _PrayerTimesPageState();
}

class _PrayerTimesPageState extends State<PrayerTimesPage> {
  String selectedCityArabic = "القاهرة";

  @override
  void initState() {
    super.initState();
    final cubit = context.read<HomeCubit>();
    cubit.getPrayerTimes(egyptCitiesMap[selectedCityArabic]!);
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final cubit = context.read<HomeCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text("مواقيت الصلاة"), centerTitle: true),

      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primary.withOpacity(0.10), primary.withOpacity(0.03)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Column(
          children: [
            const SizedBox(height: 20),

            /// ===========================
            ///   اختيار المحافظة (Dropdown)
            /// ===========================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: DropdownButton<String>(
                  value: selectedCityArabic,
                  isExpanded: true,
                  underline: const SizedBox(),
                  dropdownColor: Theme.of(context).cardColor,
                  iconEnabledColor: primary,
                  items: egyptCitiesMap.keys.map((cityArabic) {
                    return DropdownMenuItem(
                      value: cityArabic,
                      child: Text(
                        cityArabic,
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCityArabic = value!;
                    });
                    cubit.getPrayerTimes(egyptCitiesMap[selectedCityArabic]!);
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// ===========================
            ///         بيانات الصلاة
            /// ===========================
            Expanded(
              child: BlocBuilder<HomeCubit, Homestate>(
                builder: (context, state) {
                  if (state is PrayerLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is PrayerErrorState) {
                    return Center(
                      child: Text(
                        "خطأ: ${state.message}",
                        style: const TextStyle(color: Colors.red, fontSize: 18),
                      ),
                    );
                  }

                  if (state is PrayerSuccessState) {
                    final t = state.data.timings;

                    return ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        const SizedBox(height: 10),
                        PrayerCard("الفجر", t.fajr, Icons.brightness_5_rounded),
                        PrayerCard("الظهر", t.dhuhr, Icons.wb_sunny_rounded),
                        PrayerCard("العصر", t.asr, Icons.timelapse_rounded),
                        PrayerCard(
                          "المغرب",
                          t.maghrib,
                          Icons.nights_stay_rounded,
                        ),
                        PrayerCard("العشاء", t.isha, Icons.nightlight_round),
                      ],
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrayerCard extends StatelessWidget {
  final String name;
  final String time;
  final IconData icon;

  const PrayerCard(this.name, this.time, this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 🔹 الاسم
          Text(
            name,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),

          // 🔹 الوقت + الأيقونة
          Row(
            children: [
              Icon(icon, color: primary, size: 24),
              const SizedBox(width: 8),
              Text(
                _convertTo12Hour(time),
                style: TextStyle(
                  color: primary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _convertTo12Hour(String time24) {
    try {
      final parts = time24.split(":");
      int h = int.parse(parts[0]);
      final m = parts[1];

      final suffix = h >= 12 ? "PM" : "AM";
      if (h > 12) h -= 12;
      if (h == 0) h = 12;

      return "$h:$m $suffix";
    } catch (_) {
      return time24;
    }
  }
}
