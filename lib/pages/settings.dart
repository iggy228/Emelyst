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
  String _brokerUrl = '';
  int _brokerPort = 10000;

  String _dbUrl = '';
  int _dbPort = 3306;

  void initFormValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _formKey.currentState.setState(() {
      _brokerUrl = prefs.getString('brokerUrl');
      _brokerPort = prefs.getInt('brokerPort');

      _dbUrl = prefs.getString('dbUrl');
      _dbPort = prefs.getInt('dbPort');
    });
  }

  void saveUrl() async {
    if (_formKey.currentState.validate()) {
      SharedPreferences pref = await SharedPreferences.getInstance();

      pref.setString('brokerUrl', _brokerUrl);
      pref.setInt('brokerPort', _brokerPort);

      pref.setString('dbUrl', _dbUrl);
      pref.setInt('dbPort', _dbPort);

      Navigator.pushReplacementNamed(context, '/loading');
    }
  }

  @override
  void initState() {
    super.initState();
    initFormValues();
  }

  @override
  Widget build(BuildContext context) {
    initFormValues();

    print(_brokerUrl);
    return RadialBackground(
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    /// field for address of broker
                    TextFormField(
                      style: Theme.of(context).textTheme.bodyText2,
                      initialValue: _brokerUrl,
                      decoration: InputDecoration(
                        hintText: 'Zadaj adresu brokera',
                      ),
                      onChanged: (url) {
                        _brokerUrl = url;
                      },
                      validator: (url) {
                        if (url == '' || url == null) {
                          return 'Nezadal si platnu adresu';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 16),
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

                    SizedBox(height: 16),
                    /// field for DB address
                    TextFormField(
                      style: Theme.of(context).textTheme.bodyText2,
                      initialValue: _dbUrl,
                      decoration: InputDecoration(
                        hintText: 'Zadaj adresu na Databazu',
                      ),
                      onChanged: (url) {
                        _dbUrl = url;
                      },
                      validator: (url) {
                        if (url == '' || url == null) {
                          return 'Nezadal si platnu adresu';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
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
          ),
          Navigation(),
        ],
      ),
    );
  }
}
