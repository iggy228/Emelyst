import 'package:emelyst/components/header.dart';
import 'package:emelyst/components/navigation.dart';
import 'package:emelyst/components/radial_background.dart';
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
      ]
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
  }

  @override
  Widget build(BuildContext context) {
    return RadialBackground(
      child: Column(
        children: [
          Header(),
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
                    Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Teplota',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Emelyst',
                              fontSize: 24,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'icons/temperature.png',
                                width: 60,
                                height: 60,
                              ),
                              Text(
                                '25°C',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontFamily: 'GillSans'
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Box for humidity
                    Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Vlhkosť',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Emelyst',
                              fontSize: 24,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'icons/humidity.png',
                                width: 60,
                                height: 60,
                              ),
                              Text(
                                '80%',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontFamily: 'GillSans'
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
                          minY: 20,
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
                              reservedSize: 12,
                              margin: 4,
                              getTextStyles: (value) => const TextStyle(color: Colors.white, fontSize: 12),
                              // ignore: missing_return
                              getTitles: (value) {
                                makeBottomTitle(value);
                              },
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
