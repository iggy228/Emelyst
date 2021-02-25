import 'package:emelyst/model/Room.dart';
import 'package:emelyst/model/Sensor.dart';
import 'package:emelyst/service/home_data.dart';
import 'package:emelyst/service/mqtt_client_wrapper.dart';
import 'package:emelyst/widgets/door_card.dart';
import 'package:emelyst/widgets/header.dart';
import 'package:emelyst/widgets/header_icon_box.dart';
import 'package:emelyst/widgets/navigation.dart';
import 'package:emelyst/widgets/radial_background.dart';
import 'package:emelyst/widgets/road_card.dart';
import 'package:emelyst/widgets/shutter_box.dart';
import 'package:flutter/material.dart';

class Security extends StatefulWidget {
  @override
  _SecurityState createState() => _SecurityState();
}

class _SecurityState extends State<Security> {

  List<Sensor<bool>> shutters = [];

  List<Sensor<bool>> doors = [
    Sensor<bool>(name: 'Dvere', data: false, topic: 'von/vchod/servo'),
    Sensor<bool>(name: 'Garáž', data: false, topic: 'prizemie/garaz/motorcek'),
  ];

  Sensor<bool> comingRoad = Sensor(name: 'Príjazdová cesta', data: false, topic: 'von/prijazd/motorcek');

  void setOnMessage() {
    MqttClientWrapper.getMessage((topic, message) {
      if (topic.contains(comingRoad.topic)) {
        setState(() {
          comingRoad.data = message == 'on' ? true : false;
        });
      }

      for (Sensor<bool> sensor in doors) {
        if (topic.contains(sensor.topic)) {
          setState(() {
            sensor.data = message == 'on' ? true : false;
          });
        }
      }

      for (Sensor<bool> sensor in shutters) {
        if (topic.contains(sensor.topic)) {
          setState(() {
            sensor.data = message == 'on' ? true : false;
          });
        }
      }
    });
  }

  void generateShuttersList() async {
    List<Room> rooms = HomeData.allRoomsData;

    for (Room room in rooms) {
      for (Sensor<bool> sensor in room.sensors) {
        if (sensor.topic.contains('motorcek') && sensor.topic != doors[1].topic && sensor.topic != comingRoad.topic) {
          shutters.add(Sensor(
            name: sensor.topic.split('/')[1],
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
    List data = routeData['data'];
    int prevIndex = index - 1 < 0 ? data.length - 1 : index - 1;
    int nextIndex = index + 1 >= data.length ? 0 : index + 1;

    if (shutters.isEmpty) {
      generateShuttersList();
    }

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
            },
            prevRouteData: {
              'data': data,
              'index': nextIndex,
            },
          ),
          Expanded(
            child: ListView(
              children: [
                HeaderIconBox('security', 'icons/security.png'),
                DoorCard(name: doors[0].name, data: doors[0].data,
                  openIcon: 'icons/door_open.png',
                  closeIcon: 'icons/door_close.png',
                  onClick: () => MqttClientWrapper.publish(doors[0].topic, doors[0].data ? 'off' : 'on'),
                ),
                DoorCard(name: doors[1].name, data: doors[1].data,
                  openIcon: 'icons/garage_open.png',
                  closeIcon: 'icons/garage_close.png',
                  onClick: () => MqttClientWrapper.publish(doors[1].topic, doors[1].data ? 'off' : 'on'),
                ),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                  color: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Rolety',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                      Container(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: shutters.length,
                          itemBuilder: (BuildContext context, int i) {
                            return ShutterBox(
                              name: shutters[i].name,
                              data: shutters[i].data,
                              onClick: () => MqttClientWrapper.publish(shutters[i].topic, shutters[i].data ? 'off' : 'on')
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 4, 16, 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                'Všetky rolety:',
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                            Column(
                              children: [
                                FlatButton(
                                  onPressed: () {
                                    shutters.forEach((shutter) {
                                      MqttClientWrapper.publish(shutter.topic, 'on');
                                    });
                                  },
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                  child: Text(' Otvoriť '),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    shutters.forEach((shutter) {
                                      MqttClientWrapper.publish(shutter.topic, 'off');
                                    });
                                  },
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                  child: Text('Zatvoriť'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                RoadCard(
                  data: comingRoad.data,
                  onPress: () => MqttClientWrapper.publish(comingRoad.topic, comingRoad.data ? 'off' : 'on'),
                ),
              ],
            ),
          ),
          Navigation(),
        ],
      ),
    );
  }
}
