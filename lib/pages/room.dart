import 'package:emelyst/model/Room.dart';
import 'package:emelyst/model/Sensor.dart';
import 'package:emelyst/service/mqtt_client_wrapper.dart';
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
  Map roomData;
  String floorPrefix;

  List<Sensor> sensors = [];

  void generateSensorsList(Map room) {
    room['sensors'].forEach((sensor) {
      if (sensor == SensorTypes.light) {
        sensors.add(Sensor(name: 'Svetlo', data: false, prefix: '$floorPrefix${room["prefix"]}/svetlo'));
      }
      if (sensor == SensorTypes.engine) {
        sensors.add(Sensor(name: 'Roleta', data: false, prefix: '$floorPrefix${room["prefix"]}/motorcek'));
      }
      if (sensor == SensorTypes.detector) {
        sensors.add(Sensor(name: 'Pohyb', data: false, prefix: '$floorPrefix${room["prefix"]}/pohyb'));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    MqttClientWrapper.onMessage((topic, message) {
      sensors.forEach((sensor) {
        if (topic.contains(sensor.prefix)) {
          setState(() {
            sensor.data = message == 'on' ? true : false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    roomData = data['roomData'];
    floorPrefix = data['floorPrefix'];

    if (sensors.isEmpty) {
      generateSensorsList(roomData);
      sensors.forEach((sensor) {
        MqttClientWrapper.subscribe(sensor.prefix);
      });
    }

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
                  onPress: () => MqttClientWrapper.publish(sensors[index].prefix, sensors[index].data ? 'off' : 'on'),
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
