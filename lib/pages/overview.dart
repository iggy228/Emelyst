import 'dart:async';

import 'package:emelyst/model/FamilyMember.dart';
import 'package:emelyst/model/Sensor.dart';
import 'package:emelyst/service/home_data.dart';
import 'package:emelyst/service/mqtt_client_wrapper.dart';
import 'package:emelyst/service/sensors_state.dart';
import 'package:emelyst/widgets/family_member_box.dart';
import 'package:emelyst/widgets/header_navigation.dart';
import 'package:emelyst/widgets/header_icon_box.dart';
import 'package:emelyst/widgets/navigation.dart';
import 'package:emelyst/widgets/radial_background.dart';
import 'package:emelyst/widgets/sensor_card.dart';
import 'package:emelyst/widgets/chart_card.dart';
import 'package:flutter/material.dart';

class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  Map<String, double> avgTemperatures = {'0': 0};
  Map<String, double> avgHumidity = {'0': 0};

  List<FamilyMember> familyMembers = [];

  List<Sensor<double>> sensorsData = [
    Sensor<double>(name: 'teplota', data: 0, topic: 'von/meteo/teplota'),
    Sensor<double>(name: 'vlhkost', data: 0, topic: 'von/meteo/vlhkost'),
  ];

  Future<void> initTemperature() async {
    Map<String, double> temperatures = await SensorState.getAvgTemperature();
    Map<String, double> humidities = await SensorState.getAvgHumidity();
    sensorsData[0].data = await SensorState.getLastTemperature();
    sensorsData[1].data = await SensorState.getLastHumidity();
    setState(() {
      avgTemperatures = temperatures;
      avgHumidity = humidities;
    });
  }

  @override
  void initState() {
    super.initState();

    familyMembers = HomeData.allUsers;

    sensorsData.forEach((sensor) {
      MqttClientWrapper.subscribe(sensor.topic);
    });

    MqttClientWrapper.getMessage((topic, message) {
      print(topic);
      print(message);
      switch (topic) {
        case "EMELYST/karta/otec/stav":
          {
            setState(() {
              familyMembers[0].isHome = message == "1";
              familyMembers[0].updateDate();
            });
            break;
          }
        case "EMELYST/karta/mama/stav":
          {
            setState(() {
              familyMembers[1].isHome = message == "1";
              familyMembers[1].updateDate();
            });
            break;
          }
        case "EMELYST/karta/syn/stav":
          {
            setState(() {
              familyMembers[2].isHome = message == "1";
              familyMembers[2].updateDate();
            });
            break;
          }
        case "EMELYST/karta/dcera/stav":
          {
            setState(() {
              familyMembers[3].isHome = message == "1";
              familyMembers[3].updateDate();
            });
            break;
          }
      }

      for (Sensor sensor in sensorsData) {
        if (topic.contains(sensor.topic)) {
          setState(() {
            sensor.data = double.parse(message);
          });
        }
      }
    });

    initTemperature();

    Timer.periodic(Duration(seconds: 30), (timer) {
      print('Updating');
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Map routeData = ModalRoute.of(context).settings.arguments;
    int index = routeData['index'];
    List categories = routeData['categories'];
    int prevIndex = index - 1 < 0 ? categories.length - 1 : index - 1;
    int nextIndex = index + 1 >= categories.length ? 0 : index + 1;

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
              children: [
                HeaderIconBox(name: 'info', iconUrl: 'icons/info.png'),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Image.asset('images/house.png'),
                ),

                /// row for boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    /// Box for temperature
                    SensorCard(
                      title: 'Teplota',
                      data: sensorsData[0].data,
                      postfix: '°C',
                      iconUrl: 'temperature',
                    ),

                    /// Box for humidity
                    SensorCard(
                      title: 'Vlhkosť',
                      data: sensorsData[1].data,
                      postfix: '%',
                      iconUrl: 'humidity',
                    ),
                  ],
                ),

                Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(24)),
                  child: Column(children: <Widget>[
                    Text('Moja rodina',
                        style: Theme.of(context).textTheme.headline4),
                    const SizedBox(height: 20),
                    Container(
                      height: 160,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: familyMembers.length,
                        itemBuilder: (_, int index) {
                          return FamilyMemberBox(
                            name: familyMembers[index].name,
                            avatarIcon: familyMembers[index].iconUrl,
                            stateText: familyMembers[index].isHome ? 'doma' : 'preč',
                            timeText: familyMembers[index].getLastTime(),
                          );
                        },
                      ),
                    )
                  ]),
                ),
                // box for temperature chart
                ChartCard(
                  color: Theme.of(context).primaryColor,
                  title: 'Priemerná denná teplota za týždeň',
                  data: avgTemperatures,
                ),
                // box for humidity chart
                ChartCard(
                  color: Colors.red,
                  title: 'Priemerná denná vlhkost za týždeň',
                  data: avgHumidity,
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
    familyMembers = [];
  }
}
