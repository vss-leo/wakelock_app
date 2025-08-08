import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

/// Simplified alarm scheduler. On Android uses AlarmManager, on iOS uses local
/// notifications only. For this prototype we schedule a one-shot.
class AlarmScheduler {
  static final FlutterLocalNotificationsPlugin _flnp =
      FlutterLocalNotificationsPlugin();

  /// Schedules a one-time alarm at [scheduled] and optionally repeats.
  Future<void> scheduleAlarm(DateTime scheduled, int id) async {
    tzdata.initializeTimeZones();
    final now = DateTime.now();
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    final tz.TZDateTime tzScheduled = tz.TZDateTime.from(scheduled, tz.local);
    // Schedule local notification for iOS and fallback.
    const androidDetails = AndroidNotificationDetails(
      'alarm_channel',
      'Alarms',
      importance: Importance.max,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);
    await _flnp.zonedSchedule(
      id,
      'Alarm',
      'Time to wake up',
      tzScheduled,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
    // Android exact alarm scheduling.
    await AndroidAlarmManager.oneShotAt(
      scheduled,
      id,
      _alarmCallback,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
  }

  /// A static callback required for Android alarms. This simply triggers
  /// notifications, actual ring logic should be triggered via app side.
  static Future<void> _alarmCallback() async {
    // nothing for now
  }
}