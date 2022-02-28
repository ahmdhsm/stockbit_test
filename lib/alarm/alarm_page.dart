import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notification_service.dart';
import '../clock/clock.dart';

class AlarmPage extends ConsumerWidget {
  late ClockController clockController;
  NotificationService notificationService= NotificationService();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    clockController = ClockController(250);
    notificationService.context = context;
    notificationService.checkNotifikasi();
    clockController.onRotateDone = () {
      notificationService.showScheduledNotification(
        clockController.currentHour(),
        clockController.currentMinute(),
      );
    };
    // alarm.setNotification();
    return Scaffold(
      appBar: AppBar(
        title: Text("Alarm App"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Clock(clockController),
          ],
        ),
      ),
    );
  }
}
