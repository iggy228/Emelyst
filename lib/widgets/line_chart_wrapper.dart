import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartWrapper extends StatelessWidget {

  List<LineChartBarData> chartData = [
    LineChartBarData(
      spots: [
        FlSpot(1, 23),
        FlSpot(2, 28),
        FlSpot(3, 33),
        FlSpot(4, 30),
        FlSpot(5, 28),
        FlSpot(6, 33),
        FlSpot(7, 31),
      ],
      colors: [
        Color.fromRGBO(52, 192, 209, 1),
      ],
    ),
  ];

  String makeBottomTitle(value) {
    switch (value.toInt()) {
      case 1: return 'PO';
      case 2: return 'UT';
      case 3: return 'ST';
      case 4: return 'ŠT';
      case 5: return 'PI';
      case 6: return 'SO';
      case 7: return 'NE';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: chartData,
        minY: 10,
        maxY: 40,
        gridData: FlGridData(
          show: false,
        ),
        borderData: FlBorderData(
          border: Border(bottom: BorderSide(color: Colors.white), left: BorderSide(color: Colors.white)),
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
              interval: 5
          ),
        ),
      ),
    );
  }
}
