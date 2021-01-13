import 'package:emelyst/model/Room.dart';
import 'package:emelyst/model/Sensor.dart';
import 'package:emelyst/service/mqtt_client_wrapper.dart';
import 'package:emelyst/widgets/header.dart';
import 'package:emelyst/widgets/header_grid_view.dart';
import 'package:emelyst/widgets/header_icon_box.dart';
import 'package:emelyst/widgets/light_card.dart';
import 'package:emelyst/widgets/navigation.dart';
import 'package:emelyst/widgets/radial_background.dart';
import 'package:flutter/material.dart';

class Lights extends StatefulWidget {
  @override
  _LightsState createState() => _LightsState();
}

class _LightsState extends State<Lights> {

  String floorPrefix;
  List roomsData;

  List<Sensor<bool>> lights = [];

  void generateLightsList(List roomsData) {
    roomsData.forEach((room) {
      if (room['sensors'].any((i) => i == SensorTypes.light)) {
        lights.add(Sensor<bool>(name: room['name'], data: false, prefix: '$floorPrefix${room["prefix"]}/svetlo'));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    MqttClientWrapper.onMessage((topic, message) {
      lights.forEach((light) {
        if (topic.contains(light.prefix)) {
          setState(() {
            light.data = message == 'on' ? true : false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Map routeData = ModalRoute.of(context).settings.arguments;
    int index = routeData['index'];
    List data = routeData['data'];
    floorPrefix = routeData['floorPrefix'];
    roomsData = routeData['roomsData'];

    if (lights.isEmpty) {
      generateLightsList(roomsData);
      lights.forEach((light) {
        MqttClientWrapper.subscribe(light.prefix);
      });
    }

    int prevIndex = index - 1 < 0 ? data.length - 1 : index - 1;
    int nextIndex = index + 1 >= data.length ? 0 : index + 1;

    return RadialBackground(
      child: Column(
        children: [
          Header(
            title: data[index]['name'],
            nextRouteUrl: data[nextIndex]['url'],
            prevRouteUrl: data[prevIndex]['url'],
            nextRouteData: {
              'data': data,
              'index': nextIndex,
              'floorPrefix': routeData['floorPrefix'],
              'roomsData': routeData['roomsData'],
            },
            prevRouteData: {
              'data': data,
              'index': nextIndex,
              'floorPrefix': routeData['floorPrefix'],
              'roomsData': routeData['roomsData'],
            },
          ),
          Expanded(
            child: HeaderGridView(
              header: HeaderIconBox('lights', 'icons/light_off.png'),
              itemCount: lights.length,
              itemBuilder: (BuildContext context, int index) {
                return LightCard(
                  title: lights[index].name,
                  text: lights[index].data ? 'on' : 'off',
                  color: lights[index].data ? Colors.amberAccent : Colors.white,
                  iconUrl: lights[index].data ? 'icons/light_on.png' : 'icons/light_off.png',
                  onPress: () {
                    MqttClientWrapper.publish(lights[index].prefix, lights[index].data ? 'off' : 'on');
                  }
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
    lights.forEach((light) {
      MqttClientWrapper.unsubscribe(light.prefix);
    });
    super.dispose();
  }
}
