import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:qapp/services/notificationservices/notification_service.dart';
import 'package:qapp/model/PrayerTimings/payerservices.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qapp/data/cubit/home_cubit.dart';

class NotificationsTestScreen extends StatefulWidget {
  const NotificationsTestScreen({super.key});

  @override
  State<NotificationsTestScreen> createState() =>
      _NotificationsTestScreenState();
}

class _NotificationsTestScreenState extends State<NotificationsTestScreen> {
  List<PendingNotificationRequest> _pending = [];
  String _currentTimezone = "";
  String _currentTime = "";

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final pending = await NotificationService.getPendingNotifications();
    setState(() {
      _pending = pending;
      _currentTimezone = tz.local.name;
      _currentTime = tz.TZDateTime.now(tz.local).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications Test"),
        actions: [
          IconButton(onPressed: _refresh, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _infoCard("Time Information", {
            "Timezone": _currentTimezone,
            "Device Time": _currentTime,
          }),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text("Test Mode (Mock Prayers)"),
              const Spacer(),
              Switch(
                value: PrayerService.debugMode,
                onChanged: (v) {
                  setState(() => PrayerService.debugMode = v);
                },
              ),
            ],
          ),
          const Divider(),
          Wrap(
            spacing: 8,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await NotificationService.testNotification(30);
                  _refresh();
                },
                child: const Text("Test Notif (30s)"),
              ),
              ElevatedButton(
                onPressed: () async {
                  context.read<HomeCubit>().getPrayerTimes(
                    "Cairo",
                  ); // Trigger reschedule
                  _refresh();
                },
                child: const Text("Reschedule Prayers"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade100,
                ),
                onPressed: () async {
                  await NotificationService.cancelAllPrayers();
                  _refresh();
                },
                child: const Text("Cancel All Prayers"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await NotificationService.rescheduleAll();
                  _refresh();
                },
                child: const Text("Reschedule Everything"),
              ),
            ],
          ),
          const Divider(),
          const Text(
            "Pending Notifications",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (_pending.isEmpty)
            const Center(child: Text("No pending notifications"))
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _pending.length,
              itemBuilder: (context, index) {
                final req = _pending[index];
                return Card(
                  child: ListTile(
                    title: Text("[${req.id}] ${req.title}"),
                    subtitle: Text(req.body ?? ""),
                    trailing: const Icon(Icons.notifications_active, size: 16),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _infoCard(String title, Map<String, String> data) {
    return Card(
      elevation: 0,
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const Divider(),
            ...data.entries.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Text(
                      "${e.key}: ",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Expanded(
                      child: Text(
                        e.value,
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
