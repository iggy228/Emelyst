import 'package:emelyst/model/FamilyMember.dart';
import 'package:emelyst/model/Room.dart';
import 'package:emelyst/service/home_data.dart';
import 'package:emelyst/service/mqtt_client_wrapper.dart';
import 'package:emelyst/service/sensors_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum WhereLoading {
  HOME,
  SETTINGS
}

class Loading extends StatefulWidget {
  
  final WhereLoading whereLoading;
  
  Loading({this.whereLoading = WhereLoading.HOME});
  
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  List<Room> rooms = [];
  String _serverUrl = '192.168.0.5';
  int _brokerPort = 1883;
  int _dbPort = 3306;

  String _username = 'emelyst';
  String _password = 'emelyst';
  String _dbname = 'emelyst';

  bool isError = false;
  String errorMessage = "";

  Future<void> setupConnectionToBroker() async {
    await MqttClientWrapper.connect(url: _serverUrl, port: _brokerPort);
    if (!MqttClientWrapper.isConnected) {
      isError = true;
      errorMessage += "Nepodarilo sa pripojiť na broker.\n";
    }
  }

  Future<void> connectToDB() async {
    bool connected = await SensorState.connect(
      url: _serverUrl,
      port: _dbPort,
      username: _username,
      password: _password,
      db: _dbname,
    );
    if (!connected) {
      isError = true;
      errorMessage += "Nepodarilo sa pripojiť na databázu.\n";
    }
  }

  Future<void> setupSensorsData() async {

    List data = [];
    List<FamilyMember> users = [];

    try {
      data = await SensorState.getData();
      users = await SensorState.getUsers();
    }
    catch (e) {
      isError = true;
      errorMessage += "Nepodarilo sa získať dáta z databázy.\n";
      return;
    }

    HomeData.setData(data, users);
  }

  void _setupApp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString('serverUrl') != null && prefs.getInt('brokerPort') != null
    && prefs.getInt('dbPort') != null) {
      _serverUrl = prefs.getString('serverUrl');
      _brokerPort = prefs.getInt('brokerPort');
      _dbPort = prefs.getInt('dbPort');

      _username = prefs.getString('username');
      _password = prefs.getString('password');
      _dbname = prefs.getString('dbname');
    }

    if (widget.whereLoading == WhereLoading.HOME) {
      await setupConnectionToBroker();
      await connectToDB();
      if (!isError) {
        await setupSensorsData();
      }
    }
    
    if (isError) {
      Navigator.pushReplacementNamed(context, '/loadingError', arguments: <String, dynamic>{
        'error': errorMessage,
        'brokerPort': _brokerPort,
        'serverUrl': _serverUrl,
        'dbPort': _dbPort,
        'username': _username,
        'password': _password,
        'dbname': _dbname,
      });
    }
    else if (widget.whereLoading == WhereLoading.SETTINGS) {
      Navigator.pushReplacementNamed(context, '/settings', arguments: <String, dynamic>{
        'brokerPort': _brokerPort,
        'serverUrl': _serverUrl,
        'dbPort': _dbPort,
        'username': _username,
        'password': _password,
        'dbname': _dbname,
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
