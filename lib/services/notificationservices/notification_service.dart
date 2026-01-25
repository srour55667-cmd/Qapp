import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:qapp/services/notificationservices/zekrmodel.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';
import 'dart:math';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel dhikrChannel =
      AndroidNotificationChannel(
        'dhikr_channel',
        'Dhikr Reminder',
        description: 'Periodic Dhikr Notifications',
        importance: Importance.max,
        playSound: true,
      );

  static const AndroidNotificationChannel prayerChannel =
      AndroidNotificationChannel(
        'prayer_channel',
        'Prayer Times',
        description: 'Notifications for Prayer Times',
        importance: Importance.max,
        playSound: true,
      );

  static Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    // iOS setup
    final ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final initSettings = InitializationSettings(android: android, iOS: ios);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        if (kDebugMode) {
          print(
            "Notification received in foreground/background: ${response.payload}",
          );
        }
      },
    );

    // Create Channel for Android
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(dhikrChannel);

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(prayerChannel);

    // PERMISSIONS (Especially Android 13+)
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  /// Cancels all notifications and schedules the next batch (e.g., 3 days worth).
  /// This ensures reliability without a background service.
  static Future<void> rescheduleAll() async {
    await _plugin.cancelAll();
    await _scheduleBatchDhikr();
    // Re-schedule prayers logic would go here too if needed
  }

  static const int _dhikrStartId = 100;
  static const int _dhikrCount = 48;

  static Future<void> _scheduleBatchDhikr() async {
    // Legacy wrapper if needed or just use the new name
    await scheduleDhikrAfterTwoHours();
  }

  static Future<void> scheduleDhikrAfterTwoHours() async {
    // Schedule every 2 hours for the next 4 days.
    // 4 days * 12 notifs/day = 48 notifications.

    final now = tz.TZDateTime.now(tz.local);

    for (int i = 0; i < _dhikrCount; i++) {
      // 2 hours interval
      final scheduledTime = now.add(Duration(hours: 2 * (i + 1)));

      await _plugin.zonedSchedule(
        _dhikrStartId + i,
        "ذكر الله",
        getRandomDhikr(),
        scheduledTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'dhikr_channel',
            'Dhikr Reminder',
            channelDescription: 'Periodic Dhikr Notifications',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: "dhikr",
      );
    }

    if (kDebugMode) {
      print(
        "Scheduled $_dhikrCount notifications starting from ${now.add(const Duration(hours: 2))}",
      );
    }
  }

  static Future<void> cancelDhikr() async {
    for (int i = 0; i < _dhikrCount; i++) {
      await _plugin.cancel(_dhikrStartId + i);
    }
    if (kDebugMode) {
      print("Cancelled all Dhikr notifications");
    }
  }

  static String getRandomDhikr() {
    if (ZekrModel.adhkarList.isEmpty) return "سبحان الله";
    final random = Random();
    return ZekrModel.adhkarList[random.nextInt(ZekrModel.adhkarList.length)];
  }

  static DateTime parsePrayerDateTime(String timeStr, DateTime date) {
    try {
      final cleanTime = timeStr.split('(')[0].trim();
      final parts = cleanTime.split(':');
      return DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error parsing prayer time ($timeStr): $e");
      }
      return date;
    }
  }

  static Future<void> cancelAllPrayers() async {
    // Assuming IDs 200 to 1000 are for prayers
    for (int i = 200; i < 1000; i++) {
      await _plugin.cancel(i);
    }
  }

  static Future<void> scheduleOneTimePrayer(
    int id,
    String title,
    DateTime scheduledTime,
  ) async {
    try {
      final tzTime = tz.TZDateTime.from(scheduledTime, tz.local);
      if (tzTime.isBefore(tz.TZDateTime.now(tz.local))) return;

      if (kDebugMode) {
        print("Scheduling prayer: $title at $tzTime (ID: $id)");
      }

      await _plugin.zonedSchedule(
        id,
        title,
        'حان الآن موعد صلاة $title',
        tzTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'prayer_channel',
            'Prayer Times',
            channelDescription: 'Notifications for Prayer Times',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: 'prayer_$title',
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error scheduling prayer: $e");
      }
    }
  }

  // Deprecated or single-use wrapper
  static Future<void> schedulePrayer(
    int id,
    String title,
    DateTime scheduledTime,
  ) async {
    await scheduleOneTimePrayer(id, title, scheduledTime);
  }

  static Future<List<PendingNotificationRequest>>
  getPendingNotifications() async {
    return await _plugin.pendingNotificationRequests();
  }

  static Future<void> testNotification(int seconds) async {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledTime = now.add(Duration(seconds: seconds));
    final id = Random().nextInt(100);

    if (kDebugMode) {
      print("Scheduling TEST notification at $scheduledTime (ID: $id)");
    }

    await _plugin.zonedSchedule(
      id,
      "Test Notification",
      "This is a test notification firing after $seconds seconds.",
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Test Notifications',
          channelDescription: 'For testing purposes',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'test_notification',
    );
  }
}
