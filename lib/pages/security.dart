import 'package:emelyst/widgets/door_card.dart';
import 'package:emelyst/widgets/header.dart';
import 'package:emelyst/widgets/navigation.dart';
import 'package:emelyst/widgets/radial_background.dart';
import 'package:flutter/material.dart';

class Security extends StatefulWidget {
  @override
  _SecurityState createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  @override
  Widget build(BuildContext context) {
    return RadialBackground(
      child: Column(
        children: [
          Header(
            title: 'Ochrana',
          ),

          Expanded(
            child: Column(
              children: [
                DoorCard(name: 'Dvere', data: true, openIcon: 'icons/door_open.png', closeIcon: 'icons/door_close.png'),
                DoorCard(name: 'Garaz', data: true, openIcon: 'icons/garage_open.png', closeIcon: 'icons/garage_close.png'),
              ],
            )
          ),
          Navigation(),
        ],
      ),
    );
  }
}
