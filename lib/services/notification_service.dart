import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../models/application.dart';
import '../models/application_status.dart';
import '../utils/constants.dart';
import 'reminder_calculator.dart';

/// Local deadline + follow-up reminders. Everything is on-device;
/// no server, no account, no network.
class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialised = false;

  static const String _channelId = 'applytrack_reminders';
  static const String _channelName = 'Application reminders';
  static const String _channelDescription =
      'Deadlines and follow-ups for your applications';

  Future<void> initialise() async {
    if (_initialised) return;
    try {
      tzdata.initializeTimeZones();
      try {
        final zone = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(zone.identifier));
      } catch (_) {
        tz.setLocalLocation(tz.local);
      }
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const settings = InitializationSettings(android: androidSettings);
      await _plugin.initialize(settings: settings);
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      _initialised = true;
    } catch (_) {
      // Reminders are a bonus, never a crash: the app works without them.
      _initialised = false;
    }
  }

  NotificationDetails get _details => const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
      );

  Future<void> scheduleForApplication(
    Application app, {
    int leadDays = AppConstants.defaultReminderLeadDays,
  }) async {
    if (!_initialised || app.id == null) return;
    await cancelForApplication(app.id!);
    if (app.deadline != null && !app.status.isTerminal) {
      final when = ReminderCalculator.reminderDateTime(
        app.deadline!,
        leadDays: leadDays,
        hour: AppConstants.defaultReminderHour,
      );
      if (when != null) {
        await _schedule(
          id: ReminderCalculator.deadlineNotificationId(app.id!),
          title: 'Deadline soon: ${app.company}',
          body: '${app.role} closes in $leadDays day(s).',
          when: when,
        );
      }
    }
    if (app.followUpDate != null && !app.status.isTerminal) {
      final when = ReminderCalculator.reminderDateTime(
        app.followUpDate!,
        leadDays: 0,
        hour: AppConstants.defaultReminderHour,
      );
      if (when != null) {
        await _schedule(
          id: ReminderCalculator.followUpNotificationId(app.id!),
          title: 'Follow up: ${app.company}',
          body: 'Follow up on your ${app.role} application today.',
          when: when,
        );
      }
    }
  }

  Future<void> _schedule({
    required int id,
    required String title,
    required String body,
    required DateTime when,
  }) async {
    try {
      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.from(when, tz.local),
        notificationDetails: _details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (_) {
      // Scheduling can fail on some devices; ignore silently.
    }
  }

  Future<void> cancelForApplication(int applicationId) async {
    if (!_initialised) return;
    try {
      await _plugin.cancel(
        id: ReminderCalculator.deadlineNotificationId(applicationId),
      );
      await _plugin.cancel(
        id: ReminderCalculator.followUpNotificationId(applicationId),
      );
    } catch (_) {
      // Ignore.
    }
  }

  Future<void> cancelAll() async {
    if (!_initialised) return;
    try {
      await _plugin.cancelAll();
    } catch (_) {
      // Ignore.
    }
  }
}
