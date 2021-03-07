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

  Future<void> generateSensorsList(String roomName) async {
    sensors = HomeData.getSensorsInRoom(roomName);

    setOnMessage();
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    List<Room> roomsData = data['roomsData'];
    int index = data['index'];

    if (sensors.isEmpty) {
      generateSensorsList(roomsData[index].name);
    }

    return RadialBackground(
      child: Column(
        children: [
          Header(
            title: roomsData[index].name,
            prevRouteUrl: '/room',
            nextRouteUrl: '/room',
            nextRouteData: {
              'index': index + 1 > roomsData.length ? 0 : index + 1,
              'roomsData': roomsData
            },
            prevRouteData: {
              'index': index - 1 < 0 ? roomsData.length : index - 1,
              'roomsData': roomsData
            },
          ),
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
