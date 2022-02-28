import 'dart:math';

import 'package:flutter/material.dart';

typedef void MyCallback();

class ClockController extends ChangeNotifier {
  final double size;

  double radius = 0;
  double _radianPerTick = 0;
  double minuteRadian = 0;
  double hourRadian = 0;
  double hourDouble = 0;

  bool rotateHour = true;

  int minute = 0;
  int hour = 12;
  int minuteBefore = 0;
  int minuteAfter = 0;

  int currentHour() => hour ~/ 5;
  int currentMinute() => minute;

  Offset minutePosition = const Offset(0, 0);

  double degreeToRadians(double degrees) => degrees * (pi / 180);
  double hourToMinuteRadian(double clock) => degreeToRadians(clock / 5 * 360);
  double radianToClock(double radian) => radian / _radianPerTick;
  double hourToRadian(int clock) => degreeToRadians(clock / 12 * 360);
  double minuteToHourRadian(int minute) {
    double hourDegree = degreeToRadians((minute / 60 * 30) + (hour * 30));
    return hourDegree;
  }

  MyCallback ?onRotateDone;

  ClockController(this.size) {
    radius = size / 2;
    _radianPerTick = (6 * pi / 180);
  }

  void setRotateHour() {
    rotateHour = true;
  }

  setRotateMinute() {
    rotateHour = false;
  }

  void rotate(DragUpdateDetails d) {
    double degree = 0;
    double tanAB = 0;
    double x = d.localPosition.dx;
    double y = d.localPosition.dy;

    if (x >= radius) {
      if (y <= radius) {
        y = radius - y;

        double a = x - radius;
        double b = y;
        tanAB = atan(a / b);
      } else {
        y = y - radius;

        double a = x - radius;
        double b = y;
        tanAB = atan(b / a) + degreeToRadians(90);
      }
    } else {
      if (y <= radius) {
        y = radius - y;
        x = radius - x;

        double a = x;
        double b = y;
        tanAB = atan(b / a) + degreeToRadians(270);
      } else {
        y = y - radius;
        x = radius - x;

        double a = x;
        double b = y;
        tanAB = atan(a / b) + degreeToRadians(180);
      }
    }

    if (rotateHour) {
      hourRadian = tanAB;
      hour = radianToClock(hourRadian).toInt();
      hourDouble = radianToClock(hourRadian);

      double hourRemaining = hourDouble % 5;
      minuteRadian = hourToMinuteRadian(hourRemaining);
      minute = radianToClock(minuteRadian).toInt();
    } else {
      minuteRadian = tanAB;

      minute = radianToClock(minuteRadian).toInt();

      hourRadian = minuteToHourRadian(minute);
      minuteBefore = minuteAfter;
      minuteAfter = minute;
      if (minute == 0 && minuteBefore == 59) { 
        if (hour < 12) {
          hour += 1;
          hourRadian = hourToRadian(hour);
        } else {
          hour = 1;
          hourRadian = hourToRadian(hour);
        }
      }
      print(minuteBefore.toString() + " " + minuteAfter.toString());
    }

    notifyListeners();
  }
}
