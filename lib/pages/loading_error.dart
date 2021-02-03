import 'package:emelyst/widgets/radial_background.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingError extends StatefulWidget {
  @override
  _LoadingErrorState createState() => _LoadingErrorState();
}

class _LoadingErrorState extends State<LoadingError> {

  final _formKey = GlobalKey<FormState>();
  String _url = '';
  int _port = 0;

  void saveUrl() async {
    if (_formKey.currentState.validate()) {
      SharedPreferences pref = await SharedPreferences.getInstance();

      pref.setString('url', _url);
      pref.setInt('port', _port);

      Navigator.pushReplacementNamed(context, '/loading');
    }
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;

    String message = data['error'];
    _url = data['url'];
    _port = data['port'];

    return RadialBackground(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // If is error in loading
              Text("$message", style: Theme.of(context).textTheme.headline5),

              // url address field
              TextFormField(
                style: TextStyle(color: Colors.white, fontFamily: 'GillSans', fontSize: 20),
                initialValue: _url,
                decoration: InputDecoration(
                  hintText: 'Zadaj adresu',
                ),
                onChanged: (url) {
                  _url = url;
                },
                validator: (url) {
                  if (url == '' || url == null) {
                    return 'Nezadal si ip adresu';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // port number field
              TextFormField(
                style: TextStyle(color: Colors.white, fontFamily: 'GillSans', fontSize: 20),
                initialValue: _port.toString(),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Zadaj cislo portu',
                ),
                onChanged: (port) {
                  _port = int.parse(port);
                },
                validator: (port) {
                  if (port == null) {
                    return 'Nezadal si port';
                  }
                  return null;
                },
              ),
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
