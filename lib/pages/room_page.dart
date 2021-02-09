import 'package:emelyst/model/Room.dart';
import 'package:emelyst/model/Sensor.dart';
import 'package:emelyst/service/home_data.dart';
import 'package:emelyst/service/mqtt_client_wrapper.dart';
import 'package:emelyst/widgets/header.dart';
import 'package:emelyst/widgets/light_card.dart';
import 'package:emelyst/widgets/navigation.dart';
import 'package:emelyst/widgets/radial_background.dart';
import 'package:flutter/material.dart';

class RoomPage extends StatefulWidget {
  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<RoomPage> {
  Map roomData;
  String floorPrefix;

  List<Sensor> sensors = [];

  void setOnMessage() {
    MqttClientWrapper.getMessage((topic, message) {
      for (Sensor<bool> sensor in sensors) {
        if (topic.contains(sensor.topic)) {
          setState(() {
            sensor.data = message == 'on' ? true : false;
          });
        }
      }
    });
  }

  Future<void> generateSensorsList() async {
    List<Room> rooms = HomeData.allRoomsData;

    for (Room room in rooms) {
      for (Sensor sensor in room.sensors) {
        if (sensor.sensorType == SensorType.light) {
          sensors.add(Sensor(name: 'Svetlo', data: sensor.data, topic: sensor.topic));
        }
        if (sensor.sensorType == SensorType.engine) {
          sensors.add(Sensor(name: 'Roleta', data: sensor.data, topic: sensor.topic));
        }
        if (sensor.sensorType == SensorType.detector) {
          sensors.add(Sensor(name: 'Pohyb', data: sensor.data, topic: sensor.topic));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    roomData = data['roomData'];
    floorPrefix = data['floorPrefix'];

    if (sensors.isEmpty) {
      generateSensorsList();
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
                  onPress: () => MqttClientWrapper.publish(sensors[index].topic, sensors[index].data ? 'off' : 'on'),
                );
              },
            ),
          ),
          Navigation(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    sensors.forEach((sensor) {
      MqttClientWrapper.unsubscribe(sensor.topic);
    });
    sensors = [];
    super.dispose();
  }
}
