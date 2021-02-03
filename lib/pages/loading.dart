import 'package:emelyst/model/Room.dart';
import 'package:emelyst/model/Sensor.dart';
import 'package:emelyst/service/mqtt_client_wrapper.dart';
import 'package:emelyst/service/sensors_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  List<Room> rooms = [];
  String url = '178.40.227.3';
  bool isError = false;
  String errorMessage = "";

  SensorType textToType(String text) {
    switch (text) {
      case 'svetlo': return SensorType.light;
      case 'motorcek': return SensorType.engine;
      case 'pohyb': return SensorType.detector;
      case 'servo': return SensorType.servo;
    }
    return null;
  }

  String textToIconName(String text) {
    switch (text) {
      case 'obyvacka': return 'hostroom';
      case 'spalna': return 'bedroom';
      case 'kuchyna': return 'kitchen';
    }
    return 'bedroom';
  }

  Future<void> setupConnectionToBroker() async {
    await MqttClientWrapper.connect(url: url, port: 10000);
    if (!MqttClientWrapper.isConnected) {
      isError = true;
      errorMessage += "Nepodarilo sa pripojiť na broker.\n";
    }
  }

  Future<void> connectToDB() async {
    bool connected = await SensorState.connect(url);
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
    }

    String lastroom = '';

    for (var row in data) {
      List<String> paths = row['topic'].split('/');
      if (paths[1] == 'prizemie') {
        if (lastroom != paths[2]) {
          rooms.add(Room(name: paths[2], iconName: textToIconName(paths[2]), sensors: []));
          lastroom = paths[2];
        }
        rooms[rooms.length - 1].sensors.add(Sensor<bool>(
          name: paths[3],
          data: row['stav'] == 'on' ? true : false,
          topic: '${paths[1]}/${paths[2]}/${paths[3]}',
          sensorType: textToType(paths[3]),
        ));
      }
    }
  }

  void _setupApp() async {
    await setupConnectionToBroker();
    await connectToDB();
    await setupSensorsData();

    if (isError) {
      Navigator.pushReplacementNamed(context, '/loadingError', arguments: errorMessage);
    }
    else {
      Navigator.pushReplacementNamed(context, '/home', arguments: rooms);
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
