import 'package:emelyst/model/Sensor.dart';
import 'package:emelyst/service/mqtt_client_wrapper.dart';
import 'package:emelyst/widgets/header.dart';
import 'package:emelyst/widgets/header_icon_box.dart';
import 'package:emelyst/widgets/line_chart_wrapper.dart';
import 'package:emelyst/widgets/navigation.dart';
import 'package:emelyst/widgets/radial_background.dart';
import 'package:emelyst/widgets/sensor_card.dart';
import 'package:flutter/material.dart';

class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {

  List sensorData = [
    Sensor<int>(name: 'teplota', data: 0),
    Sensor<int>(name: 'vlhkost', data: 0),
  ];

  List<String> prefixes = [
    'EMELYST/von/meteo/teplota',
    'EMELYST/von/meteo/vlhkost',
  ];

  @override
  void initState() {
    super.initState();
    prefixes.forEach((prefix) {
      MqttClientWrapper.subscribe(prefix);
    });
    MqttClientWrapper.onMessage((topic, message) {
      sensorData.forEach((light) {
        if (topic.contains(light.name)) {
          setState(() {
            light.data = int.parse(message);
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
            },
            prevRouteData: {
              'data': data,
              'index': prevIndex,
            },
          ),
          Expanded(
            child: ListView(
              children: [
                HeaderIconBox('home', 'icons/home.png'),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Image.asset('images/house.png'),
                ),
                // row for boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Box for temperature
                    SensorCard(
                      title: 'Teplota',
                      data: sensorData[0].data,
                      postfix: '°C',
                      iconUrl: 'temperature',
                    ),
                    // Box for humidity
                    SensorCard(
                      title: 'Vlhkosť',
                      data: sensorData[1].data,
                      postfix: '%',
                      iconUrl: 'humidity',
                    ),
                  ],
                ),
                // box for chart
                Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Priemerná denná teplota za týždeň',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(height: 16),
                      LineChartWrapper(),
                    ],
                  ),
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
    prefixes.forEach((prefix) {
      MqttClientWrapper.unsubscribe(prefix);
    });
  }
}
