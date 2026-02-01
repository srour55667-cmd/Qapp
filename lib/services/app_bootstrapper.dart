import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:qapp/services/notificationservices/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';

class AppBootstrapper {
  static final Stopwatch _stopwatch = Stopwatch();

  static void init() {
    _stopwatch.start();
    _log('AppBootstrapper: Started');

    // Schedule heavy tasks for after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _log('AppBootstrapper: First Frame Rendered (UI Visible)');
      _runDeferredTasks();
    });
  }

  static Future<void> _runDeferredTasks() async {
    // 1. Notifications
    await _measure('Notification Init', () async {
      await NotificationService.initialize();
      // Only request permissions if we really need to, or let the UI handle it.
      // For now we keep the check but maybe don't block.
      _checkPermissionsBackground();
    });

    // 2. Schedule Notifications (Heavy)
    await _measure('Notification Reschedule', () async {
      // We should catch errors here so it doesn't crash the background flow
      try {
        await NotificationService.rescheduleAll();
      } catch (e) {
        _log('Error rescheduling notifications: $e');
      }
    });

    _stopwatch.stop();
    _log(
      'AppBootstrapper: All deferred tasks completed in ${_stopwatch.elapsedMilliseconds}ms',
    );
  }

  static Future<void> _checkPermissionsBackground() async {
    // We don't want to show dialogs unexpectedly, so we just check status
    // or request if it's non-intrusive.
    // Ideally, permission requests should happen when the user tries to turn on a feature.
    // But keeping legacy behavior for now without blocking startup.
    final status = await Permission.notification.status;
    if (status.isDenied) {
      // Don't request here automatically to avoid popping up dialogs randomly on startup
      // after the user sees the home screen.
      // Just log it.
      _log('Notifications permissions not granted yet.');
    }
  }

  static Future<void> _measure(String name, Function action) async {
    final start = _stopwatch.elapsedMilliseconds;
    try {
      if (action is Future Function()) {
        await action();
      } else {
        action();
      }
    } catch (e) {
      _log('Error in step [$name]: $e');
    }
    final end = _stopwatch.elapsedMilliseconds;
    if (kDebugMode) {
      print('StartupStep: [$name] took ${end - start}ms');
    }
  }

  static void _log(String message) {
    if (kDebugMode) {
      print('[Bootstrapper] $message');
    }
  }
}
