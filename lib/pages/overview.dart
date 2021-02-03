import 'package:emelyst/model/Sensor.dart';
import 'package:emelyst/service/mqtt_client_wrapper.dart';
import 'package:emelyst/service/sensors_state.dart';
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

  List<double> avgTemperatures = [];

  List sensorData = [
    Sensor<double>(name: 'teplota', data: 0, topic: 'von/meteo/teplota'),
    Sensor<double>(name: 'vlhkost', data: 0, topic: 'von/meteo/vlhkost'),
  ];

  Future<void> initTemperature() async {
    avgTemperatures = await SensorState.getAvgTemperature();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    initTemperature();

    /* sensorData.forEach((sensor) {
      MqttClientWrapper.subscribe(sensor.topic);
    }); */
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
              'floorPrefix': routeData['floorPrefix'],
              'roomsData': routeData['roomsData'],
            },
            prevRouteData: {
              'data': data,
              'index': prevIndex,
              'floorPrefix': routeData['floorPrefix'],
              'roomsData': routeData['roomsData'],
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
                  children: <Widget>[
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
                      LineChartWrapper(avgTemperatures),
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
    sensorData.forEach((sensor) {
      MqttClientWrapper.unsubscribe(sensor.topic);
    });
    super.dispose();
  }
}
