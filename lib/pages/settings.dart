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
                  padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Form(
                    key: _brokerFieldKey,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            style: TextStyle(color: Colors.white, fontFamily: 'GillSans', fontSize: 20),
                            validator: (url) {
                              MqttClientWrapper.connect(url);
                              if (MqttClientWrapper.isConnected) {
                                return null;
                              }
                              return 'Zadal si neplatnu adresu';
                            },
                            initialValue: MqttClientWrapper.url,
                            decoration: InputDecoration(
                              hintText: 'Zadaj adresu brokera',
                              hintStyle: TextStyle(color: Colors.white60),
                              labelStyle: TextStyle(color: Colors.white),
                              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, -20),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
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
