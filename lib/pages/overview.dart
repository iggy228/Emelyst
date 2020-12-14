import 'package:emelyst/components/header.dart';
import 'package:emelyst/styles/radial_background.dart';
import 'package:flutter/material.dart';

class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  @override
  Widget build(BuildContext context) {
    return RadialBackground(
      child: Column(
        children: [
          Header(),
        ],
      )
    );
  }
}
