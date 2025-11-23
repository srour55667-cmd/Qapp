// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:qapp/services/notificationservices/zekrmodel.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _plugin =
//       FlutterLocalNotificationsPlugin();

//   static const AndroidNotificationChannel dhikrChannel =
//       AndroidNotificationChannel(
//         'dhikr_channel',
//         'Dhikr Reminder',
//         description: 'Periodic Dhikr Notifications every 2 hours',
//         importance: Importance.max,
//       );

//   // --------------------------
//   // تحويل وقت الصلاة من النص إلى DateTime
//   // --------------------------
//   static DateTime parsePrayerTime(String time) {
//     final now = DateTime.now();

//     final parts = time.split(":");
//     final hour = int.parse(parts[0]);
//     final minute = int.parse(parts[1]);

//     return DateTime(now.year, now.month, now.day, hour, minute);
//   }

//   // --------------------------
//   // Notification Details للصلاة
//   // --------------------------
//   static const AndroidNotificationDetails _prayerDetails =
//       AndroidNotificationDetails(
//         'prayer_channel',
//         'Prayer Notifications',
//         channelDescription: 'Prayer time alert',
//         importance: Importance.max,
//         priority: Priority.high,
//       );

//   // --------------------------
//   // جدولة صلاة واحدة
//   // --------------------------
//   static Future<void> schedulePrayer(
//     int id,
//     String prayerName,
//     DateTime dateTime,
//   ) async {
//     final tzTime = tz.TZDateTime.from(dateTime, tz.local);

//     final details = NotificationDetails(android: _prayerDetails);

//     await _plugin.zonedSchedule(
//       id,
//       "موعد صلاة $prayerName",
//       "حان الآن وقت صلاة $prayerName",
//       tzTime,
//       details,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       payload: prayerName,
//     );
//   }

//   // --------------------------
//   // initialize
//   // --------------------------
//   static Future<void> initialize() async {
//     const android = AndroidInitializationSettings('@mipmap/ic_launcher');

//     const initSettings = InitializationSettings(android: android);

//     await _plugin.initialize(initSettings);

//     await _plugin
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >()
//         ?.createNotificationChannel(dhikrChannel);
//   }

//   // --------------------------
//   // إشعار يدوي
//   // --------------------------
//   static Future<void> showSimple({
//     required String title,
//     required String body,
//   }) async {
//     const androidDetails = AndroidNotificationDetails(
//       'dhikr_channel',
//       'Dhikr Reminder',
//       channelDescription: 'General notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     const details = NotificationDetails(android: androidDetails);

//     await _plugin.show(1, title, body, details);
//   }

//   // --------------------------
//   // إشعار الذكر
//   // --------------------------
//   static Future<void> scheduleDhikrAfterTwoHours() async {
//     final now = tz.TZDateTime.now(tz.local);
//     final next = now.add(Duration(minutes: 20));

//     const androidDetails = AndroidNotificationDetails(
//       'dhikr_channel',
//       'Dhikr Reminder',
//       channelDescription: 'Notification every 20 minutes',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     final details = NotificationDetails(android: androidDetails);

//     await _plugin.zonedSchedule(
//       200,
//       "ذكر جديد",
//       getRandomDhikr(),
//       next,
//       details,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       payload: "dhikr",
//     );
//   }

//   static String getRandomDhikr() {
//     ZekrModel.adhkarList.shuffle();
//     return ZekrModel.adhkarList.first;
//   }

//   static Future<void> cancelDhikr() async {
//     await _plugin.cancel(200);
//   }
// }
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:qapp/services/notificationservices/zekrmodel.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel dhikrChannel =
      AndroidNotificationChannel(
        'dhikr_channel',
        'Dhikr Reminder',
        description: 'Periodic Dhikr Notifications every 2 hours',
        importance: Importance.max,
      );

  // =============================
  // تحويل وقت الصلاة لنوع DateTime
  // =============================
  static DateTime parsePrayerTime(String time) {
    final now = DateTime.now();
    final parts = time.split(":");

    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  // =============================
  // ضمان أن الوقت في المستقبل
  // =============================
  static DateTime ensureFuture(DateTime time) {
    if (time.isBefore(DateTime.now())) {
      return time.add(const Duration(days: 1));
    }
    return time;
  }

  // =============================
  // Notification تفاصيل الصلاة
  // =============================
  static const AndroidNotificationDetails _prayerDetails =
      AndroidNotificationDetails(
        'prayer_channel',
        'Prayer Notifications',
        channelDescription: 'Prayer time alert',
        importance: Importance.max,
        priority: Priority.high,
      );

  // =============================
  // جدولة صلاة واحدة مع ضمان الوقت
  // =============================
  static Future<void> schedulePrayer(
    int id,
    String prayerName,
    DateTime dateTime,
  ) async {
    // ضمان الوقت في المستقبل
    final safeTime = ensureFuture(dateTime);

    final tzTime = tz.TZDateTime.from(safeTime, tz.local);

    final details = NotificationDetails(android: _prayerDetails);

    await _plugin.zonedSchedule(
      id,
      "موعد صلاة $prayerName",
      "حان الآن وقت صلاة $prayerName",
      tzTime,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: prayerName,
    );
  }

  // =============================
  // initialize
  // =============================
  static Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(android: android);

    await _plugin.initialize(initSettings);

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(dhikrChannel);
  }

  // =============================
  // إشعار يدوي
  // =============================
  static Future<void> showSimple({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'dhikr_channel',
      'Dhikr Reminder',
      channelDescription: 'General notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(1, title, body, details);
  }

  // =============================
  // إشعار الذكر
  // =============================
  static Future<void> scheduleDhikrAfterTwoHours() async {
    final now = tz.TZDateTime.now(tz.local);
    final next = now.add(const Duration(minutes: 20)); // للتجربة

    const androidDetails = AndroidNotificationDetails(
      'dhikr_channel',
      'Dhikr Reminder',
      channelDescription: 'Notification every 20 minutes',
      importance: Importance.max,
      priority: Priority.high,
    );

    final details = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      200,
      "ذكر جديد",
      getRandomDhikr(),
      next,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: "dhikr",
    );
  }

  static String getRandomDhikr() {
    ZekrModel.adhkarList.shuffle();
    return ZekrModel.adhkarList.first;
  }

  static Future<void> cancelDhikr() async {
    await _plugin.cancel(200);
  }
}
