import 'package:emelyst/service/mqtt_client_wrapper.dart';
import 'package:emelyst/widgets/navigation.dart';
import 'package:emelyst/widgets/radial_background.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final _brokerFieldKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return RadialBackground(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(8, 16, 8, 8),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          key: _brokerFieldKey,
                          style: TextStyle(color: Colors.white, fontFamily: 'GillSans', fontSize: 20),
                          validator: (url) {
                            List<String> urlSplit = url.split(':');
                            MqttClientWrapper.connect(url: urlSplit[0], port: int.parse(urlSplit[1]));
                            if (MqttClientWrapper.isConnected) {
                              return null;
                            }
                            return 'Zadal si neplatnu adresu';
                          },
                          initialValue: '${MqttClientWrapper.url}:${MqttClientWrapper.port}',
                          decoration: InputDecoration(
                            hintText: 'Zadaj adresu brokera',
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      FlatButton(
                        color: Colors.white,
                        onPressed: () => _brokerFieldKey.currentState.validate(),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: EdgeInsets.all(8),
                        child: Text('Connect'),
                      ),
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
