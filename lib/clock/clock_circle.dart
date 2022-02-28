import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClockCircle extends CustomPainter {
  final double circleSize;
  final double shortIndicator = 20;
  final double longIndicator = 25;
  double radius = 0;

  ClockCircle(this.circleSize) {
    radius = circleSize / 2;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (int i = 0; i < 60; i++) {
      double minuteDegree = 360 / 60 * i;
      
      paint.color = Colors.grey;
      paint.strokeWidth = 1;
      
      double distance = shortIndicator;

      if (i % 5 == 0) {
        paint.color = Colors.green;
        paint.strokeWidth = 3;

        distance = longIndicator;
      }

      final double radians = minuteDegree * pi / 180;
      
      final double x1 = radius * cos(radians);
      final double y1 = radius * sin(radians);
      final Offset offset1 = Offset(x1, y1);

      double x2 = (radius - distance) * cos(radians);
      double y2 = (radius - distance) * sin(radians);
      final Offset offset2 = Offset(x2, y2);

      canvas.drawLine(offset1, offset2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
    // throw UnimplementedError();
  }
}
