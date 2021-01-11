import 'package:emelyst/model/Sensor.dart';
import 'package:emelyst/service/mqtt_client_wrapper.dart';
import 'package:emelyst/widgets/header.dart';
import 'package:emelyst/widgets/header_grid_view.dart';
import 'package:emelyst/widgets/header_icon_box.dart';
import 'package:emelyst/widgets/light_card.dart';
import 'package:emelyst/widgets/navigation.dart';
import 'package:emelyst/widgets/radial_background.dart';
import 'package:flutter/material.dart';

class Lights extends StatefulWidget {
  @override
  _LightsState createState() => _LightsState();
}

class _LightsState extends State<Lights> {

  String prefix;
  List roomsPrefixis;

  List<Sensor<bool>> lights = [];

  void generateLightsList(List<String> prefixes) {
    prefixes.forEach((element) {
      lights.add(Sensor<bool>(name: element, data: false));
    });
  }

  @override
  void initState() {
    super.initState();
    MqttClientWrapper.onMessage((topic, message) {
      print(topic);
      lights.forEach((light) {
        if (topic.contains(light.name)) {
          setState(() {
            light.data = message == 'on' ? true : false;
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
    prefix = routeData['prefix'];
    roomsPrefixis = routeData['roomsPrefixes'];

    if (lights.isEmpty) {
      generateLightsList(roomsPrefixis);
      lights.forEach((light) {
        MqttClientWrapper.subscribe(prefix + light.name + '/svetlo');
      });
    }

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
                    MqttClientWrapper.publish(prefix + lights[index].name + '/svetlo', lights[index].data ? 'off' : 'on');
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
      MqttClientWrapper.unsubscribe(prefix + light.name + '/svetlo');
    });
    super.deactivate();
  }
}
