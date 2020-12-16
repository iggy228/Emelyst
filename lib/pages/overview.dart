import 'package:emelyst/widgets/header.dart';
import 'package:emelyst/widgets/navigation.dart';
import 'package:emelyst/widgets/radial_background.dart';
import 'package:emelyst/widgets/sensor_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  
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
    return RadialBackground(
      child: Column(
        children: [
          Header(title: 'Prehľad'),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Image.asset('images/house.png'),
                ),
                // row for boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Box for temperature
                    SensorCard(
                      title: 'Teplota',
                      data: 25,
                      postfix: '°C',
                      iconUrl: 'temperature',
                    ),
                    // Box for humidity
                    SensorCard(
                      title: 'Vlhkosť',
                      data: 80,
                      postfix: '%',
                      iconUrl: 'humidity',
                    ),
                  ],
                ),
                // box for chart
                Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Priemerná denná teplota za týždeň',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Emelyst',
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      LineChart(
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
                              getTextStyles: (value) => const TextStyle(color: Colors.white, fontSize: 12),
                              getTitles: (value) {
                                return makeBottomTitle(value);
                              },
                            ),
                            leftTitles: SideTitles(
                              showTitles: true,
                              getTextStyles: (value) => const TextStyle(color: Colors.white),
                              interval: 5
                            )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Navigation(),
        ],
      ),
    );
  }
}
