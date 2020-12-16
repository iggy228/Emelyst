import 'package:emelyst/widgets/header.dart';
import 'package:emelyst/widgets/navigation.dart';
import 'package:emelyst/widgets/radial_background.dart';
import 'package:flutter/material.dart';

class Room extends StatefulWidget {
  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> {
  @override
  Widget build(BuildContext context) {
    return RadialBackground(
      child: Column(
        children: [
          Header(title: 'Izba'),
          Expanded(
            child: Text(
              'Tu bude dizajn pre izbu. (WIP)',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Navigation(),
        ],
      ),
    );
  }
}
