import 'package:emelyst/widgets/header.dart';
import 'package:emelyst/widgets/header_icon_box.dart';
import 'package:emelyst/widgets/navigation.dart';
import 'package:emelyst/widgets/radial_background.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final _formKey = GlobalKey<FormState>();
  String _serverUrl = '';
  int _brokerPort = 10000;

  int _dbPort = 3306;

  void saveUrl() async {
    if (_formKey.currentState.validate()) {
      SharedPreferences pref = await SharedPreferences.getInstance();

      pref.setString('serverUrl', _serverUrl);
      pref.setInt('brokerPort', _brokerPort);

      pref.setInt('dbPort', _dbPort);

      Navigator.pushReplacementNamed(context, '/loading');
    }
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;

    _serverUrl = data['serverUrl'];
    _brokerPort = data['brokerPort'];

    _dbPort = data['dbPort'];

    print(_serverUrl);
    return RadialBackground(
      child: Column(
        children: [
          Header(
            title: 'Nastavenia',
          ),
          Expanded(
            child: ListView(
              children: [
                HeaderIconBox('settings', 'icons/settings.png'),
                SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: <Widget>[
                        /// field for address of broker
                        TextFormField(
                          style: Theme.of(context).textTheme.bodyText2,
                          initialValue: _serverUrl,
                          decoration: InputDecoration(
                            hintText: 'Zadaj adresu brokera',
                          ),
                          onChanged: (url) {
                            _serverUrl = url;
                          },
                          validator: (url) {
                            if (url == '' || url == null) {
                              return 'Nezadal si platnu adresu';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 12),
                        /// field for port number of broker
                        TextFormField(
                          style: Theme.of(context).textTheme.bodyText2,
                          initialValue: _brokerPort.toString(),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Zadaj cislo portu brokera',
                          ),
                          onChanged: (port) {
                            _brokerPort = int.parse(port);
                          },
                          validator: (port) {
                            if (port == null) {
                              return 'Nezadal si port';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 12),
                        /// field for port number of DB
                        TextFormField(
                          style: Theme.of(context).textTheme.bodyText2,
                          initialValue: _dbPort.toString(),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Zadaj cislo portu databazy',
                          ),
                          onChanged: (port) {
                            _dbPort = int.parse(port);
                          },
                          validator: (port) {
                            if (port == null) {
                              return 'Nezadal si port';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 12),
                        /// submit button
                        FlatButton(
                          color: Colors.white,
                          onPressed: () => saveUrl(),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          padding: EdgeInsets.all(8),
                          child: Text('Connect!'),
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
