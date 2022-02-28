// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'clock.dart';
import '../main.dart';

final clockNotifierProvider = ChangeNotifierProvider
    .family<ClockController, ClockController>((ref, clockController) {
  return clockController;
});

class ClockHand extends ConsumerWidget {
  final ClockController clockController;

  late AnimationController ctrl;

  ClockHand(this.clockController);

  double degreeToRadians(double degrees) => degrees * (pi / 180);

  roundToBase(double number, int base) {
    double reminder = number % base;
    double result = number;
    if (reminder < (base / 2)) {
      result = number - reminder;
    } else {
      result = number + (base - reminder);
    }
    return result;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _clockProvider = ref.watch(clockNotifierProvider(clockController));
    return GestureDetector(
      onPanUpdate: _clockProvider.rotate,
      onPanEnd: (DragEndDetails d){
        _clockProvider.onRotateDone!();
      },
      child: Container(
        width: clockController.size - 50,
        height: clockController.size - 50,
        decoration: const BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.rotate(
              angle: _clockProvider.minuteRadian,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 3,
                  height: clockController.size - (clockController.size * 0.3),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.transparent,
                        Color(0xff65D1BA),
                        Color(0xff65D1BA),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Transform.rotate(
              angle: _clockProvider.hourRadian,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 5,
                  height: clockController.size - (clockController.size * 0.5),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.transparent,
                        Colors.green,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
