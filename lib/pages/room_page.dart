import 'package:emelyst/model/Room.dart';
import 'package:emelyst/model/Sensor.dart';
import 'package:emelyst/service/home_data.dart';
import 'package:emelyst/service/mqtt_client_wrapper.dart';
import 'package:emelyst/widgets/header_navigation.dart';
import 'package:emelyst/widgets/header_icon_box.dart';
import 'package:emelyst/widgets/header_list_view.dart';
import 'package:emelyst/widgets/navigation.dart';
import 'package:emelyst/widgets/radial_background.dart';
import 'package:emelyst/widgets/room_sensor_card.dart';
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

  String typeToIcon(SensorType sensorType, bool data) {
    if (sensorType == SensorType.light) {
      return data ? 'icons/light_on.png' : 'icons/light_off.png';
    }
    if (sensorType == SensorType.engine) {
      return data ? 'icons/shutter_open.png' : 'icons/shutter_close.png';
    }
    if (sensorType == SensorType.alarm) {
      return data ? 'icons/alarm_on.png' : 'icons/alarm.png';
    }
    return data ? 'icons/garage_open.png' : 'icons/garage_close.png';
  }

  String typeToButtonText(SensorType sensorType, bool data) {
    if (sensorType == SensorType.light || sensorType == SensorType.alarm) {
      return data ? 'vypnúť' : 'zapnúť';
    }
    return data ? 'zatvoriť' : 'otvoriť';
  }

  String typeToStateText(SensorType sensorType, bool data) {
    if (sensorType == SensorType.light || sensorType == SensorType.alarm) {
      return data ? 'zapnuté' : 'vypnuté';
    }
    return data ? 'otvorené' : 'zatvorené';
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
        children: <Widget>[
          HeaderNavigation(
            title: roomsData[index].name,
            prevRouteUrl: '/room',
            nextRouteUrl: '/room',
            nextRouteData: {
              'index': index + 1 < roomsData.length ? index + 1 : 0,
              'roomsData': roomsData
            },
            prevRouteData: {
              'index': index - 1 < 0 ? roomsData.length - 1 : index - 1,
              'roomsData': roomsData
            },
          ),
          Expanded(
            child: HeaderListView(
              header: HeaderIconBox(
                name: roomsData[index].iconName,
                iconUrl: 'icons/${roomsData[index].iconName}.png',
                iconWidth: 60,
              ),
              itemCount: sensors.length,
              itemBuilder: (BuildContext context, int index) {
                return RoomSensorCard(
                  title: sensors[index].name,
                  iconUrl: typeToIcon(
                      sensors[index].sensorType, sensors[index].data),
                  buttonText: typeToButtonText(
                      sensors[index].sensorType, sensors[index].data),
                  stateText: typeToStateText(
                      sensors[index].sensorType, sensors[index].data),
                  buttonColor:
                      sensors[index].data ? Colors.amberAccent : Colors.white,
                  onPress: () => MqttClientWrapper.publish(
                      sensors[index].topic, sensors[index].data ? 'off' : 'on'),
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
