import 'package:flutter/material.dart';
import 'line_chart_wrapper.dart';

class ChartCard extends StatelessWidget {
  final Color color;
  final String title;
  List<double> _data = [];
  List<String> _dates = [];

  ChartCard({this.color, this.title, Map<String, double> data}) {
    for (double i in data.values) {
      _data.add(i);
    }
    for (String i in data.keys) {
      _dates.add(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 20),
            LineChartWrapper(data: _data, color: color, dates: _dates),
          ],
        ),
      ),
    );
  }
}