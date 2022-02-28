import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:stockbit_test/alarm/detail_page.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:fluttertoast/fluttertoast.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationService {
  int notificationHour = 0;
  int notificationMinute = 0;
  int notificationSecond = 0;
  var context;

  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  // function to count different time
  int countSecond(tz.TZDateTime startTime, tz.TZDateTime endTime) {
    Duration diff = endTime.difference(startTime);
    return diff.inSeconds;
  }

  // initialization function that called in main
  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      // onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: null,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  // event when user tap on notification
  void selectNotification(String? payload) async {
    tz.TZDateTime nowTime = tz.TZDateTime.now(tz.local);
    notificationHour = nowTime.hour;
    notificationMinute = nowTime.minute;
    notificationSecond = nowTime.second;
    var strSplit = payload?.split("-");

    int duration = int.parse(strSplit![0]);
    var clockSplit = strSplit[1].split(" ");

    int hour = int.parse(clockSplit[0]);

    tz.TZDateTime nextTime = tz.TZDateTime.local(
      nowTime.year,
      nowTime.month,
      nowTime.day,
      hour,
      int.parse(clockSplit[1]),
      int.parse(clockSplit[2]),
    );

    int difference = countSecond(nowTime, nextTime);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DetailPage(duration, difference.abs())),
    );
  }

  // register scheduled notification
  showScheduledNotification(int hour, int minute) async {
    await flutterLocalNotificationsPlugin.cancelAll();
    tz.TZDateTime nowTime = tz.TZDateTime.now(tz.local);

    if (nowTime.hour > 12) {
      hour += 12;
    }

    int second = nowTime.second;

    tz.TZDateTime nextTime = tz.TZDateTime.local(
        nowTime.year, nowTime.month, nowTime.day, hour, minute, second);

    int difference = countSecond(nowTime, nextTime);

    if (nextTime.isBefore(nowTime)) {
      Fluttertoast.showToast(
          msg: "Cannot set alarm",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    Fluttertoast.showToast(
        msg: "Alaram set fro $difference seconds",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Alarm Title',
      'Alarm Body',
      tz.TZDateTime.now(tz.local).add(Duration(seconds: difference)),
      const NotificationDetails(
        android: AndroidNotificationDetails('122333333', 'my channel name',
            channelDescription: 'my channel description'),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: difference.toString() + "-" + "$hour $minute $second",
    );
  }

  // used to determine if this app opened from notification
  Future<void> checkNotifikasi() async {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp == true) {
      if (notificationAppLaunchDetails?.payload != null) {
        selectNotification(notificationAppLaunchDetails?.payload);
      }
    }
  }
}
