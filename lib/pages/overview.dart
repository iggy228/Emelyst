import 'package:emelyst/model/Sensor.dart';
import 'package:emelyst/widgets/header.dart';
import 'package:emelyst/widgets/header_icon_box.dart';
import 'package:emelyst/widgets/line_chart_wrapper.dart';
import 'package:emelyst/widgets/navigation.dart';
import 'package:emelyst/widgets/radial_background.dart';
import 'package:emelyst/widgets/sensor_card.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {

  MqttServerClient mqttClient;

  List sensorData = [
    Sensor(name: 'teplota', data: 0),
    Sensor(name: 'vlhkost', data: 0),
  ];

  // Method for connecting to MQTT broker
  Future<void> mqttConnect() async {
    mqttClient = MqttServerClient.withPort('test.mosquitto.org', 'mobileID-15662', 1883);

    try {
      await mqttClient.connect();
    } catch (e) {
      print('This is your error: $e');
    }

    for (int i = 0; i < sensorData.length; i++) {
      mqttClient.subscribe(sensorData[i].name, MqttQos.atLeastOnce);
    }
    mqttClient.updates.listen((event) {
      MqttPublishMessage message = event[0].payload;
      double data = double.parse(MqttPublishPayload.bytesToStringAsString(message.payload.message));


      // Recognizing right topic
      for (int i = 0; i < sensorData.length; i++) {
        if (event[0].topic == sensorData[i].name) {
          setState(() {
            sensorData[i].data = data;
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    mqttConnect();
  }

  @override
  Widget build(BuildContext context) {
    return RadialBackground(
      child: Column(
        children: [
          Header(title: 'Prehľad'),
          HeaderIconBox('home', 'icons/home.png'),
          Expanded(
            child: ListView(
              children: [
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
}
