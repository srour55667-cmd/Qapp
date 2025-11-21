import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart' show HijriCalendar;
import 'dart:async';

class Timeandhijri extends StatefulWidget {
  const Timeandhijri({super.key});

  @override
  State<Timeandhijri> createState() => _TimeandhijriState();
}

class _TimeandhijriState extends State<Timeandhijri> {
  late String timeString;
  late String hijriDate;
  @override
  void initState() {
    super.initState();
    timeString = _formatCurrentTime();
    hijriDate = _getHijriDate();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
  }

  void _updateTime() {
    setState(() {
      timeString = _formatCurrentTime();
      hijriDate = _getHijriDate();
    });
  }

  String _formatCurrentTime() {
    final now = DateTime.now();
    return DateFormat('hh:mm a').format(now);
  }

  String _getHijriDate() {
    final hijriNow = HijriCalendar.now();
    return '${hijriNow.getLongMonthName()} ${hijriNow.hDay}, ${hijriNow.hYear} AH';
  }

  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(timeString, style: const TextStyle(fontSize: 20)),
        Text(hijriDate, style: const TextStyle(fontSize: 20)),
      ],
    );
  }
}
