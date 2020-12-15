import 'package:emelyst/widgets/header.dart';
import 'package:emelyst/widgets/light_card.dart';
import 'package:emelyst/widgets/navigation.dart';
import 'package:emelyst/widgets/radial_background.dart';
import 'package:emelyst/model/Light.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class Lights extends StatefulWidget {
  @override
  _LightsState createState() => _LightsState();
}

class _LightsState extends State<Lights> {

  MqttServerClient mqttClient;

  List lights = [
    Light(name: 'kuchyna', data: false),
    Light(name: 'spalna', data: false),
    Light(name: 'garaz', data: false),
    Light(name: 'obyvacka', data: false),
  ];

  Future<void> mqttConnect() async {
    mqttClient = MqttServerClient.withPort('test.mosquitto.org', 'mobileID-15662', 1883);

    try {
      await mqttClient.connect();
    } catch (e) {
      print('This is your error: $e');
    }

    for (int i = 0; i < lights.length; i++) {
      mqttClient.subscribe(lights[i].name, MqttQos.atLeastOnce);
    }
    mqttClient.updates.listen((event) {
      MqttPublishMessage message = event[0].payload;
      var data = MqttPublishPayload.bytesToStringAsString(message.payload.message);
      print(data);
      for (int i = 0; i < lights.length; i++) {
        if (event[0].topic == lights[i].name) {
          setState(() {
            lights[i].data = data == 'true' ? true : false;
          });
        }
      }
    });
  }

  void mqttPublishMessage(int index) async {
    final builder = MqttClientPayloadBuilder();
    builder.addString(lights[index].data ? 'false' : 'true');
    mqttClient.publishMessage(lights[index].name, MqttQos.atLeastOnce, builder.payload);
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
          Header(title: 'Svetlá'),
          Expanded(
            child: GridView.builder(
              itemCount: lights.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (BuildContext context, int index) {
                return LightCard(
                  title: lights[index].name,
                  data: lights[index].data,
                  onPress: () {
                    setState(() {
                      mqttPublishMessage(index);
                    });
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
  void deactivate() {
    mqttClient.disconnect();
    super.deactivate();
  }
}
