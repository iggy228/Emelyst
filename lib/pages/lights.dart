import 'package:emelyst/service/mqtt_client_wrapper.dart';
import 'package:emelyst/widgets/header.dart';
import 'package:emelyst/widgets/header_grid_view.dart';
import 'package:emelyst/widgets/header_icon_box.dart';
import 'package:emelyst/widgets/light_card.dart';
import 'package:emelyst/widgets/navigation.dart';
import 'package:emelyst/widgets/radial_background.dart';
import 'package:emelyst/model/Light.dart';
import 'package:flutter/material.dart';

class Lights extends StatefulWidget {
  @override
  _LightsState createState() => _LightsState();
}

class _LightsState extends State<Lights> {

  List lights = [
    Light(name: 'kuchyna', data: false),
    Light(name: 'spalna', data: false),
    Light(name: 'garaz', data: false),
    Light(name: 'obyvacka', data: false),
  ];

  @override
  void initState() {
    super.initState();
    lights.forEach((light) {
      MqttClientWrapper.subscribe(light.name);
    });
    MqttClientWrapper.onMessage((topic, message) {
      lights.forEach((light) {
        if (topic == light.name) {
          setState(() {
            light.data = message == 'true' ? true : false;
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
              'index': nextIndex,
            },
          ),
          Expanded(
            child: HeaderGridView(
              header: HeaderIconBox('lights', 'icons/light_off.png'),
              itemCount: lights.length,
              itemBuilder: (BuildContext context, int index) {
                return LightCard(
                  title: lights[index].name,
                  data: lights[index].data,
                  onPress: () {
                    MqttClientWrapper.publish(lights[index].name, lights[index].data ? 'false' : 'true');
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
    lights.forEach((light) {
      MqttClientWrapper.unsubscribe(light.name);
    });
    super.deactivate();
  }
}
