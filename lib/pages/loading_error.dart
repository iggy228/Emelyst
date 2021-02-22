import 'package:emelyst/widgets/radial_background.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingError extends StatefulWidget {
  @override
  _LoadingErrorState createState() => _LoadingErrorState();
}

class _LoadingErrorState extends State<LoadingError> {

  final _formKey = GlobalKey<FormState>();
  String _brokerUrl;
  int _brokerPort = 0;

  String _dbUrl;
  int _dbPort = 0;

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
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;

    print(data['brokerPort'].runtimeType);

    String message = data['error'];
    _brokerUrl = data['brokerUrl'];
    _brokerPort = data['brokerPort'];

    _dbUrl = data['dbUrl'];
    _dbPort = data['dbPort'];

    return RadialBackground(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // If is error in loading
              Text("$message", style: Theme.of(context).textTheme.headline5),

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
    );
  }
}
