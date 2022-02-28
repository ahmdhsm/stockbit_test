import 'package:flutter/material.dart';
import 'package:stockbit_test/clock/clock_hand.dart';

import 'clock_circle.dart';
import 'clock_controller.dart';

export 'clock_controller.dart';

class Clock extends StatefulWidget {
  final ClockController clockController;
  const Clock(this.clockController, {Key? key}) : super(key: key);

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  double minuteHandLong = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    minuteHandLong = (widget.clockController.size * 0.5) * 0.8;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(painter: ClockCircle(widget.clockController.size)),
        ClockHand(widget.clockController)
      ],
    );
  }
}
