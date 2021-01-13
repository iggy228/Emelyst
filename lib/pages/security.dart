import 'package:emelyst/model/Room.dart';
import 'package:emelyst/model/Sensor.dart';
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
  String floorPrefix;
  List roomsData;

  List<Sensor<bool>> shutters = [];

  List<Sensor<bool>> doors = [
    Sensor<bool>(name: 'Dvere', data: false, prefix: 'von/vchod/vstup'),
    Sensor<bool>(name: 'Garáž', data: false, prefix: 'von/vchod/servo'),
  ];

  Sensor<bool> comingRoad = Sensor(name: 'Príjazdová cesta', data: false, prefix: 'von/prijazd/motorcek');

  void generateShuttersList(List roomsData) {
    roomsData.forEach((room) {
      if (room['sensors'].any((i) => i == SensorTypes.engine)) {
        shutters.add(Sensor<bool>(name: room['name'], data: false, prefix: '$floorPrefix${room["prefix"]}/motorcek'));
      }
    });
  }


  @override
  void initState() {
    super.initState();
    doors.forEach((door) {
      MqttClientWrapper.subscribe(door.prefix);
    });
    MqttClientWrapper.subscribe(comingRoad.prefix);

    MqttClientWrapper.onMessage((topic, message) {
      shutters.forEach((shutter) {
        if (topic.contains(shutter.prefix)) {
          setState(() {
            shutter.data = message == 'true' ? true : false;
          });
        }
      });
      doors.forEach((door) {
        if (topic.contains(door.prefix)) {
          setState(() {
            door.data = message == 'true' ? true : false;
          });
        }
      });

      if (topic.contains(comingRoad.prefix)) {
        setState(() {
          comingRoad.data = message == 'true' ? true : false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Map routeData = ModalRoute.of(context).settings.arguments;
    int index = routeData['index'];
    List data = routeData['data'];
    floorPrefix = routeData['floorPrefix'];
    roomsData = routeData['roomsData'];
    int prevIndex = index - 1 < 0 ? data.length - 1 : index - 1;
    int nextIndex = index + 1 >= data.length ? 0 : index + 1;

    if (shutters.isEmpty) {
      generateShuttersList(roomsData);
      shutters.forEach((sensor) {
        MqttClientWrapper.subscribe(sensor.prefix);
      });
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
            child: ListView(
              children: [
                HeaderIconBox('security', 'icons/security.png'),
                DoorCard(name: doors[0].name, data: doors[0].data,
                  openIcon: 'icons/door_open.png',
                  closeIcon: 'icons/door_close.png',
                  onClick: () => MqttClientWrapper.publish(doors[0].prefix, doors[0].data ? 'false' : 'true'),
                ),
                DoorCard(name: doors[1].name, data: doors[1].data,
                  openIcon: 'icons/garage_open.png',
                  closeIcon: 'icons/garage_close.png',
                  onClick: () => MqttClientWrapper.publish(doors[1].prefix, doors[1].data ? 'false' : 'true'),
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
                              onClick: () => MqttClientWrapper.publish(shutters[i].prefix, shutters[i].data ? 'false' : 'true')
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
                                      MqttClientWrapper.publish(shutter.prefix, 'true');
                                    });
                                  },
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                  child: Text(' Otvoriť '),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    shutters.forEach((shutter) {
                                      MqttClientWrapper.publish(shutter.prefix, 'false');
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
                  onPress: () => MqttClientWrapper.publish(comingRoad.prefix, comingRoad.data ? 'false' : 'true'),
                ),
              ],
            ),
          ),
          Navigation(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    shutters.forEach((sensor) {
      MqttClientWrapper.unsubscribe(sensor.prefix);
    });
    doors.forEach((sensor) {
      MqttClientWrapper.unsubscribe(sensor.prefix);
    });
    MqttClientWrapper.unsubscribe(comingRoad.prefix);
    super.dispose();
  }
}
