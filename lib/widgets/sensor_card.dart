import 'package:flutter/material.dart';

class SensorCard extends StatelessWidget {
  final String title;
  final int data;
  final String postfix;
  final String iconUrl;

  SensorCard({this.title, this.data, this.postfix, this.iconUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headline4
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'icons/$iconUrl.png',
                width: 60,
                height: 60,
              ),
              Text(
                '$data$postfix',
                style: Theme.of(context).textTheme.headline3,
              )
            ],
          ),
        ],
      ),
    );
  }
}
