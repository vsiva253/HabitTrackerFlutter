import 'package:demo/habit.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  final AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) async {
      // Handle notification tap here

      // Get the notification payload.
      final String? payload = notificationResponse.payload;

      // Get the user action.
    },
  );
}

Future<void> scheduleReminder(Habit habit) async {
  tzdata.initializeTimeZones();
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  final notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'habit_channel',
      'Habit Reminders',
      channelDescription: 'Habit reminder notifications',
    ),
  );

  for (var i = 0; i < habit.totalDays; i++) {
    final date = DateTime.now().add(Duration(days: i));
    final time = habit.reminder;

    final notificationTime = tz.TZDateTime(
        tz.local, date.year, date.month, date.day, time.hour, time.minute);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      i,
      'Reminder for ${habit.name}',
      'Don\'t forget to complete your habit today!',
      notificationTime,
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
