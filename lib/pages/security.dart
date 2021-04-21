import 'package:emelyst/model/Room.dart';
import 'package:emelyst/model/Sensor.dart';
import 'package:emelyst/service/home_data.dart';
import 'package:emelyst/service/mqtt_client_wrapper.dart';
import 'package:emelyst/widgets/door_card.dart';
import 'package:emelyst/widgets/header_navigation.dart';
import 'package:emelyst/widgets/header_icon_box.dart';
import 'package:emelyst/widgets/navigation.dart';
import 'package:emelyst/widgets/radial_background.dart';
import 'package:emelyst/widgets/road_card.dart';
import 'package:emelyst/widgets/rotating_icon.dart';
import 'package:emelyst/widgets/shutter_box.dart';
import 'package:flutter/material.dart';

class Security extends StatefulWidget {
  @override
  _SecurityState createState() => _SecurityState();
}

class _SecurityState extends State<Security> {

  bool garageLoading = false;
  bool doorLoading = false;

  List<Sensor<bool>> shutters = [];

  List<Sensor<bool>> doors = [];

  Sensor<bool> comingRoad;
  Sensor<bool> alarm;

  void setOnMessage() {
    MqttClientWrapper.getMessage((topic, message) {
      if (topic.contains(comingRoad.topic)) {
        setState(() {
          comingRoad.data = message == 'on' ? true : false;
        });
      }

      if (topic.contains(alarm.topic)) {
        setState(() {
          alarm.data = message == 'on' ? true : false;
        });
      }

      for (Sensor<bool> sensor in doors) {
        if (topic.contains(sensor.topic)) {
          setState(() {
            sensor.data = message == 'on' ? true : false;
            if (sensor.name == "Dvere") {
              doorLoading = false;
            }
            else {
              garageLoading = false;
            }
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

  void generateShuttersList() {
    List<Room> rooms = HomeData.allRoomsData;

    for (Room room in rooms) {
      for (Sensor<bool> sensor in room.sensors) {
        if (sensor.topic == 'prizemie/chodba/alarm') {
          alarm = Sensor(name: 'Alarm', data: sensor.data, topic: sensor.topic, sensorType: sensor.sensorType);
        }
        else if (sensor.topic == 'von/prijazd/motorcek') {
          comingRoad = Sensor(name: 'Príjazdová cesta', data: sensor.data, topic: sensor.topic, sensorType: sensor.sensorType);
        }
        else if (sensor.topic == 'prizemie/chodba/servo') {
          doors.add(Sensor(name: 'Dvere', data: sensor.data, topic: sensor.topic, sensorType: sensor.sensorType));
        }
        else if (sensor.topic == 'prizemie/garaz/motorcek') {
          doors.add(Sensor(name: 'Garáž', data: sensor.data, topic: sensor.topic, sensorType: sensor.sensorType));
        }
        else if (sensor.topic.contains('motorcek')) {
          shutters.add(Sensor(
            name: room.name,
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
    int prevIndex = index - 1 < 0 ? categories.length - 1 : index - 1;
    int nextIndex = index + 1 >= categories.length ? 0 : index + 1;

    if (shutters.isEmpty) {
      generateShuttersList();
    }

    return RadialBackground(
      child: Column(
        children: [
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
            child: ListView(
              children: <Widget>[
                HeaderIconBox(name: 'security', iconUrl: 'icons/security.png'),
                const SizedBox(height: 24),
                DoorCard(
                  name: doors[0].name,
                  stateIcon: doors[0].data ? 'icons/door_open.png' : 'icons/door_close.png',
                  stateText: doors[0].data ? 'otvorené' : 'zatvorené',
                  buttonText: doors[0].data ? 'zatvoriť' : 'otvoriť',
                  onClick: () {
                    MqttClientWrapper.publish(doors[0].topic, doors[0].data ? 'off' : 'on');
                    setState(() {
                      doorLoading = true;
                    });
                  },
                  animatedIcon: doorLoading ? RotatingIcon() : null,
                ),
                DoorCard(
                  name: doors[1].name,
                  stateIcon: doors[1].data ? 'icons/garage_open.png' : 'icons/garage_close.png',
                  stateText: doors[1].data ? 'otvorené' : 'zatvorené',
                  buttonText: doors[1].data ? 'zatvoriť' : 'otvoriť',
                  onClick: () {
                    MqttClientWrapper.publish(doors[1].topic, doors[1].data ? 'off' : 'on');
                    setState(() {
                      garageLoading = true;
                    });
                  },
                  animatedIcon: garageLoading ? RotatingIcon() : null,
                ),
                DoorCard(
                  name: alarm.name,
                  stateIcon: alarm.data ? 'icons/alarm_on.png' : 'icons/alarm.png',
                  stateText: alarm.data ? 'zapnuté' : 'vypnuté',
                  buttonText: alarm.data ? 'vypnúť' : 'zapnúť',
                  onClick: () => MqttClientWrapper.publish(
                      alarm.topic, alarm.data ? 'off' : 'on'),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                        child: Text(
                          'Rolety',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                      Container(
                        height: 140,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: shutters.length,
                          itemBuilder: (BuildContext context, int i) {
                            return ShutterBox(
                                name: shutters[i].name,
                                data: shutters[i].data,
                                onClick: () => MqttClientWrapper.publish(
                                    shutters[i].topic,
                                    shutters[i].data ? 'off' : 'on'));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
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
                              children: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    shutters.forEach((shutter) {
                                      MqttClientWrapper.publish(
                                          shutter.topic, 'on');
                                    });
                                  },
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24)),
                                  child: const Text(' Otvoriť '),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    shutters.forEach((shutter) {
                                      MqttClientWrapper.publish(
                                          shutter.topic, 'off');
                                    });
                                  },
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24)),
                                  child: const Text('Zatvoriť'),
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
                  onPress: () => MqttClientWrapper.publish(
                      comingRoad.topic, comingRoad.data ? 'off' : 'on'),
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
    super.dispose();
    shutters = [];
    doors = [];
  }
}
