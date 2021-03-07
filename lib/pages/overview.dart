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

  List<double> avgTemperatures = [0];
  List<double> avgHumidity = [0];

  List<Sensor<double>> sensorsData = [
    Sensor<double>(name: 'teplota', data: 0, topic: 'von/meteo/teplota'),
    Sensor<double>(name: 'vlhkost', data: 0, topic: 'von/meteo/vlhkost'),
  ];

  Future<void> initTemperature() async {
    avgTemperatures = await SensorState.getAvgTemperature();
    avgHumidity = await SensorState.getAvgHumidity();
    sensorsData[0].data = await SensorState.getLastTemperature();
    sensorsData[1].data = await SensorState.getLastHumidity();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    sensorsData.forEach((sensor) {
      MqttClientWrapper.subscribe(sensor.topic);
    });

    MqttClientWrapper.getMessage((topic, message) {
      for (Sensor sensor in sensorsData) {
        if (topic.contains(sensor.topic)) {
          setState(() {
            sensor.data = double.parse(message);
          });
        }
      }
    });

    initTemperature();
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
            child: ListView(
              children: [
                HeaderIconBox('info', 'icons/info.png'),
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
                // box for temperature chart
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
                      LineChartWrapper(data: avgTemperatures, color: Color.fromRGBO(52, 192, 209, 1)),
                    ],
                  ),
                ),
                // box for humidity chart
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
                        'Priemerná denná vlhkosť za týždeň',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(height: 16),
                      LineChartWrapper(data: avgHumidity),
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
}
