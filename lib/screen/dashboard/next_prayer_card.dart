import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qapp/core/theme/app_colors.dart';
import 'package:qapp/core/theme/app_spacing.dart';
import 'package:qapp/model/PrayerTimings/mainpayer.dart';

class NextPrayerCard extends StatefulWidget {
  final PrayerTimings timings;

  const NextPrayerCard({super.key, required this.timings});

  @override
  State<NextPrayerCard> createState() => _NextPrayerCardState();
}

class _NextPrayerCardState extends State<NextPrayerCard> {
  Timer? _timer;
  String _nextPrayerName = "";
  String _nextPrayerTimeDisplay = "";
  Duration _timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calculateNextPrayer();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateNextPrayer();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  DateTime? _parseTime(String timeStr) {
    if (timeStr.isEmpty) return null;
    try {
      // Clean up string: "04:30 PM (EEST)" -> "04:30"
      var clean = timeStr.split('(')[0].trim();
      clean = clean.replaceAll(RegExp(r'[a-zA-Z]'), '').trim();

      final parts = clean.split(':');
      if (parts.length < 2) return null;

      final now = DateTime.now();
      final h = int.tryParse(parts[0].trim());
      final m = int.tryParse(parts[1].trim());

      if (h == null || m == null) return null;

      return DateTime(now.year, now.month, now.day, h, m);
    } catch (e) {
      debugPrint("Error parsing time '$timeStr': $e");
      return null;
    }
  }

  void _calculateNextPrayer() {
    final now = DateTime.now();
    final t = widget.timings;

    // Helper to safely get DateTime or fallback
    DateTime getDT(String s) =>
        _parseTime(s) ?? now.add(const Duration(days: 99));

    final fajr = getDT(t.fajr);
    final dhuhr = getDT(t.dhuhr);
    final asr = getDT(t.asr);
    final maghrib = getDT(t.maghrib);
    final isha = getDT(t.isha);

    // Check if parsing failed for all (fallback used)
    if (fajr.year > now.year + 1) {
      if (mounted) {
        setState(() {
          _nextPrayerName = "خطأ";
          _nextPrayerTimeDisplay = "";
          _timeLeft = Duration.zero;
        });
      }
      return;
    }

    DateTime nextTime;
    String nextName;

    if (now.isBefore(fajr)) {
      nextTime = fajr;
      nextName = "الفجر";
    } else if (now.isBefore(dhuhr)) {
      nextTime = dhuhr;
      nextName = "الظهر";
    } else if (now.isBefore(asr)) {
      nextTime = asr;
      nextName = "العصر";
    } else if (now.isBefore(maghrib)) {
      nextTime = maghrib;
      nextName = "المغرب";
    } else if (now.isBefore(isha)) {
      nextTime = isha;
      nextName = "العشاء";
    } else {
      nextTime = fajr.add(const Duration(days: 1));
      nextName = "الفجر";
    }

    if (mounted) {
      setState(() {
        _nextPrayerName = nextName;
        _nextPrayerTimeDisplay =
            "${nextTime.hour.toString().padLeft(2, '0')}:${nextTime.minute.toString().padLeft(2, '0')}";
        _timeLeft = nextTime.difference(now);
      });
    }
  }

  String _formatDuration(Duration d) {
    if (d.isNegative) return "00:00:00";
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(d.inHours);
    String minutes = twoDigits(d.inMinutes.remainder(60));
    String seconds = twoDigits(d.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.35),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Subtle background pattern or icon
          Positioned(
            left: -20,
            bottom: -20,
            child: Icon(
              Icons.access_time_rounded,
              size: 100,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "الصلاة القادمة: $_nextPrayerName",
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            "موعد الصلاة: $_nextPrayerTimeDisplay",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white10),
                      ),
                      child: const Icon(
                        Icons.notifications_active_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.md,
                    horizontal: AppSpacing.lg,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "الوقت المتبقي:",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          _formatDuration(_timeLeft),
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: AppColors.accent,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
