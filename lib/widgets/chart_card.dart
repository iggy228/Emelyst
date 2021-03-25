import 'package:flutter/material.dart';
import 'line_chart_wrapper.dart';

class ChartCard extends StatelessWidget {
  final Color color;
  final String title;
  final List data;

  ChartCard({this.color, this.title, this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
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
            SizedBox(height: 20),
            LineChartWrapper(data: data, color: color),
          ],
        ),
      ),
    );
  }
}