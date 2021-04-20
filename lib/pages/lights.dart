import 'package:emelyst/model/Room.dart';
import 'package:emelyst/model/Sensor.dart';
import 'package:emelyst/service/home_data.dart';
import 'package:emelyst/service/mqtt_client_wrapper.dart';
import 'package:emelyst/widgets/header_navigation.dart';
import 'package:emelyst/widgets/header_grid_view.dart';
import 'package:emelyst/widgets/header_icon_box.dart';
import 'package:emelyst/widgets/light_card.dart';
import 'package:emelyst/widgets/light_grid_header.dart';
import 'package:emelyst/widgets/navigation.dart';
import 'package:emelyst/widgets/radial_background.dart';
import 'package:flutter/material.dart';

class Lights extends StatefulWidget {
  @override
  _LightsState createState() => _LightsState();
}

class _LightsState extends State<Lights> {

  List<Sensor<bool>> floorlights = [];
  List<Sensor<bool>> roomslights = [];

  void setOnMessage() {
    MqttClientWrapper.getMessage((topic, message) {
      for (Sensor<bool> sensor in roomslights) {
        if (topic.contains(sensor.topic)) {
          setState(() {
            sensor.data = message == 'on' ? true : false;
          });
        }
      }
      for (Sensor<bool> sensor in floorlights) {
        if (topic.contains(sensor.topic)) {
          setState(() {
            sensor.data = message == 'on' ? true : false;
          });
        }
      }
    });
  }

  Future<void> generateLightsList() async {
    List<Room> rooms = HomeData.allRoomsData;

    for (Room room in rooms) {
      for (Sensor<bool> sensor in room.sensors) {
        if (sensor.topic.contains('svetlo')) {
          if (room.name.contains('poschodie')) {
            floorlights.add(Sensor(
              name: room.name,
              data: sensor.data,
              topic: sensor.topic,
              sensorType: sensor.sensorType,
            ));
          }
          else {
            roomslights.add(Sensor(
              name: room.name,
              data: sensor.data,
              topic: sensor.topic,
              sensorType: sensor.sensorType,
            ));
          }
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

    if (floorlights.isEmpty || roomslights.isEmpty) {
      generateLightsList();
    }

    int prevIndex = index - 1 < 0 ? categories.length - 1 : index - 1;
    int nextIndex = index + 1 >= categories.length ? 0 : index + 1;

    return RadialBackground(
      child: Column(
        children: <Widget>[
          HeaderNavigation(
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
              header: HeaderIconBox(name: 'light', iconUrl: 'icons/light.png'),
              floorHeader: LightGridHeader(title: 'poschodie', iconUrl: 'icons/up.png'),
              floorCount: floorlights.length,
              floorBuilder: (BuildContext context, int index) {
                return LightCard(
                  title: floorlights[index].name,
                  text: floorlights[index].data ? 'zapnuté' : 'vypnuté',
                  color: floorlights[index].data ? Colors.amberAccent : Colors.white,
                  iconUrl: floorlights[index].data ? 'icons/light_on.png' : 'icons/light_off.png',
                  onPress: () {
                    print(floorlights[index].data);
                    MqttClientWrapper.publish(floorlights[index].topic, floorlights[index].data ? 'off' : 'on');
                  }
                );
              },
              roomHeader: LightGridHeader(title: 'prizemie', iconUrl: 'icons/down.png'),
              roomCount: roomslights.length,
              roomBuilder: (BuildContext context, int index) {
                return LightCard(
                    title: roomslights[index].name,
                    text: roomslights[index].data ? 'zapnuté' : 'vypnuté',
                    color: roomslights[index].data ? Colors.amberAccent : Colors.white,
                    iconUrl: roomslights[index].data ? 'icons/light_on.png' : 'icons/light_off.png',
                    onPress: () {
                      MqttClientWrapper.publish(roomslights[index].topic, roomslights[index].data ? 'off' : 'on');
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
    roomslights = [];
    floorlights = [];
    super.dispose();
  }
}
