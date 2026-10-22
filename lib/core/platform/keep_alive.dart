import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// Keeps the process alive while the screen is locked / app backgrounded.
///
/// Approach under test in the spike:
///   1. Android foreground service (keeps the Dart isolate running).
///   2. Wake lock (keeps the CPU/screen from sleeping mid-round).
///
/// The timer itself stays in the main isolate; the service's TaskHandler is
/// intentionally a no-op. Its only job is to stop Android killing us.
class KeepAlive {
  static bool _initialised = false;

  static void _init() {
    if (_initialised) return;
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'fightcraft_session',
        channelName: 'Fightcraft session',
        channelDescription: 'Keeps your workout running in the background.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        allowWakeLock: true,
        allowWifiLock: false,
      ),
    );
    _initialised = true;
  }

  static Future<void> start() async {
    _init();

    // Android 13+: notification permission is required for the service's
    // notification to show.
    final perm = await FlutterForegroundTask.checkNotificationPermission();
    if (perm != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }

    if (!await FlutterForegroundTask.isRunningService) {
      await FlutterForegroundTask.startService(
        serviceId: 4242,
        notificationTitle: 'Fightcraft',
        notificationText: 'Session in progress',
        serviceTypes: [ForegroundServiceTypes.mediaPlayback],
        callback: startCallback,
      );
    }
    await WakelockPlus.enable();
  }

  static Future<void> stop() async {
    await WakelockPlus.disable();
    if (await FlutterForegroundTask.isRunningService) {
      await FlutterForegroundTask.stopService();
    }
  }

  static Future<void> updateNotification(String text) async {
    if (await FlutterForegroundTask.isRunningService) {
      await FlutterForegroundTask.updateService(
        notificationTitle: 'Fightcraft',
        notificationText: text,
      );
    }
  }
}

/// Entry point for the service isolate. Must be a top-level function.
@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(_NoopHandler());
}

class _NoopHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {}

  @override
  void onRepeatEvent(DateTime timestamp) {}

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {}
}
