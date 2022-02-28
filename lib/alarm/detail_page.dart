import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DetailPage extends ConsumerWidget {
  final int waitingTime;
  final int idleTime;

  DetailPage(this.waitingTime, this.idleTime);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alarm Detail"),
      ),
      body: Center(
        child: Container(
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            series: <BarSeries<Map<String, dynamic>, String>>[
              BarSeries<Map<String, dynamic>, String>(
                // Bind data source
                dataSource: <Map<String, dynamic>>[
                  {"name": idleTime.toString(), "value": waitingTime}
                ],
                xValueMapper: (Map<String, dynamic> value, _) =>
                    value['name'].toString(),
                yValueMapper: (Map<String, dynamic> value, _) => value['value'],
              )
            ],
          ),
        ),
      ),
    );
  }
}
