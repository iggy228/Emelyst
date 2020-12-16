import 'package:emelyst/widgets/navigation.dart';
import 'package:emelyst/widgets/radial_background.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {


  @override
  Widget build(BuildContext context) {
    return RadialBackground(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [

              ],
            ),
          ),
          Navigation(),
        ],
      ),
    );
  }
}
