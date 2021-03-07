import 'package:emelyst/model/Room.dart';
import 'package:emelyst/model/Sensor.dart';
import 'package:emelyst/service/home_data.dart';
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

  List roomsData;

  List<Sensor<bool>> lights = [];

  void setOnMessage() {
    MqttClientWrapper.getMessage((topic, message) {
      for (Sensor<bool> sensor in lights) {
        if (topic.contains(sensor.topic)) {
          setState(() {
            sensor.data = message == 'on' ? true : false;
          });
        }
      }
    });
  }

  Future<void> generateLightsList(List roomsData) async {
    List<Room> rooms = HomeData.allRoomsData;

    for (Room room in rooms) {
      for (Sensor<bool> sensor in room.sensors) {
        if (sensor.topic.contains('svetlo')) {
          lights.add(Sensor(
            name: sensor.topic.split('/')[0] + ' ' + sensor.topic.split('/')[1],
            data: sensor.data,
            topic: sensor.topic,
            sensorType: sensor.sensorType,
          ));
        }
      }
    }

    setOnMessage();
  }

  @override
  Widget build(BuildContext context) {
    Map routeData = ModalRoute.of(context).settings.arguments;
    int index = routeData['index'];
    List categories = routeData['categories'];

    if (lights.isEmpty) {
      generateLightsList(roomsData);
    }

    int prevIndex = index - 1 < 0 ? categories.length - 1 : index - 1;
    int nextIndex = index + 1 >= categories.length ? 0 : index + 1;

    return RadialBackground(
      child: Column(
        children: [
          Header(
            title: categories[index]['name'],
            nextRouteUrl: categories[nextIndex]['url'],
            prevRouteUrl: categories[prevIndex]['url'],
            nextRouteData: {
              'categories': categories,
              'index': nextIndex,
            },
            prevRouteData: {
              'categories': categories,
              'index': prevIndex,
            },
          ),
          Expanded(
            child: HeaderGridView(
              header: HeaderIconBox('light', 'icons/light_off.png'),
              itemCount: lights.length,
              itemBuilder: (BuildContext context, int index) {
                return LightCard(
                  title: lights[index].name,
                  text: lights[index].data ? 'on' : 'off',
                  color: lights[index].data ? Colors.amberAccent : Colors.white,
                  iconUrl: lights[index].data ? 'icons/light_on.png' : 'icons/light_off.png',
                  onPress: () {
                    MqttClientWrapper.publish(lights[index].topic, lights[index].data ? 'off' : 'on');
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
    lights = [];
    super.dispose();
  }
}
