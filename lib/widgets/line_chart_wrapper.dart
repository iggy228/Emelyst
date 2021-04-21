import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartWrapper extends StatelessWidget {
  final List<FlSpot> _chartData = [];
  final List<String> dates;
  final Color color;

  LineChartWrapper({List<double> data, this.color = Colors.red, this.dates}) {
    for (int i = 0; i < data.length; i++) {
      FlSpot spot = FlSpot(i.toDouble(), double.parse(data[i].toStringAsFixed(2)));
      _chartData.add(spot);
    }
  }

  String makeBottomTitle(double value) {
    return dates[value.toInt()];
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: <LineChartBarData>[
          LineChartBarData(
            spots: _chartData,
            colors: [color],
          )
        ],
        gridData: FlGridData(
          show: false,
        ),
        borderData: FlBorderData(
          border: const Border(
              bottom: const BorderSide(color: Colors.white),
              left: const BorderSide(color: Colors.white)),
        ),
        titlesData: FlTitlesData(
          bottomTitles: SideTitles(
            showTitles: true,
            getTextStyles: (value) => const TextStyle(color: Colors.white),
            getTitles: (value) {
              return makeBottomTitle(value);
            },
          ),
          leftTitles: SideTitles(
              showTitles: true,
              getTextStyles: (value) => const TextStyle(color: Colors.white),
              interval: 5),
        ),
      ),
    );
  }
}
