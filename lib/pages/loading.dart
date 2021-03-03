import 'package:emelyst/model/Room.dart';
import 'package:emelyst/service/home_data.dart';
import 'package:emelyst/service/mqtt_client_wrapper.dart';
import 'package:emelyst/service/sensors_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  List<Room> rooms = [];
  String _brokerUrl = '';
  int _brokerPort = 0;

  String _dbUrl = '';
  int _dbPort = 0;

  bool isError = false;
  String errorMessage = "";

  Future<void> setupConnectionToBroker() async {
    await MqttClientWrapper.connect(url: _brokerUrl, port: _brokerPort);
    if (!MqttClientWrapper.isConnected) {
      isError = true;
      errorMessage += "Nepodarilo sa pripojiť na broker.\n";
    }
  }

  Future<void> connectToDB() async {
    bool connected = await SensorState.connect(_dbUrl, _dbPort);
    if (!connected) {
      isError = true;
      errorMessage += "Nepodarilo sa pripojiť na databázu.\n";
    }
  }

  Future<void> setupSensorsData() async {

    List data = [];

    try {
      data = await SensorState.getData();
    }
    catch (e) {
      isError = true;
      errorMessage += "Nepodarilo sa získať dáta z databázy.\n";
      return;
    }

    HomeData.setData(data);
  }

  void _setupApp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString('brokerUrl') != null && prefs.getInt('brokerPort') != null
    && prefs.getString('dbUrl') != null && prefs.getInt('dbPort') != null) {
      _brokerUrl = prefs.getString('brokerUrl');
      _brokerPort = prefs.getInt('brokerPort');

      print(_brokerUrl);

      _dbUrl = prefs.getString('dbUrl');
      _dbPort = prefs.getInt('dbPort');

      await setupConnectionToBroker();
      await connectToDB();
      if (!isError) {
        await setupSensorsData();
      }
    }
    else {
      isError = true;
    }

    if (isError) {
      Navigator.pushReplacementNamed(context, '/loadingError', arguments: <String, dynamic>{
        'error': errorMessage,
        'brokerPort': _brokerPort,
        'brokerUrl': _brokerUrl,
        'dbUrl': _dbUrl,
        'dbPort': _dbPort,
      });
    }
    else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  void initState() {
    super.initState();
    _setupApp();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(52, 192, 209, 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SpinKitFoldingCube(
            color: Colors.white
          ),
          SizedBox(height: 24),
          Text('Emelyst', style: Theme.of(context).textTheme.headline4),
       ],
      ),
    );
  }
}
