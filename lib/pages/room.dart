import 'package:emelyst/model/Sensor.dart';
import 'package:emelyst/widgets/header.dart';
import 'package:emelyst/widgets/light_card.dart';
import 'package:emelyst/widgets/navigation.dart';
import 'package:emelyst/widgets/radial_background.dart';
import 'package:flutter/material.dart';

class Room extends StatefulWidget {
  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> {
  List<Sensor> sensors = [
    Sensor(name: 'Svetlo', data: false),
    Sensor(name: 'Roleta', data: false),
  ];

  @override
  Widget build(BuildContext context) {
    Map roomData = ModalRoute.of(context).settings.arguments;


    return RadialBackground(
      child: Column(
        children: [
          Header(title: roomData['name']),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: sensors.length,
              itemBuilder: (BuildContext context, int index) {
                return LightCard(
                  title: sensors[index].name,
                  iconUrl: sensors[index].data ? 'icons/light_on.png' : 'icons/light_off.png',
                  text: sensors[index].data ? 'vypnúť' : 'zapnúť',
                  color: sensors[index].data ? Colors.amberAccent : Colors.white,
                  onPress: () {},
                );
              },
            ),
          ),
          Navigation(),
        ],
      ),
    );
  }
}
