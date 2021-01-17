import 'package:emelyst/model/Room.dart';
import 'package:emelyst/model/Sensor.dart';
import 'package:emelyst/service/mqtt_client_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mysql1/mysql1.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

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

  void setupConnectionToBroker() async {
    await MqttClientWrapper.connect(url: '91.127.16.72', port: 10000);

    var settings = ConnectionSettings(
      host: '91.127.16.72',
      port: 3306,
      user: 'david',
      password: 'barta',
      db: 'dht'
    );

    var conn = await MySqlConnection.connect(settings);

    var result = await conn.query('SELECT * FROM stav');

    List<Room> rooms = [];

    String lastroom = "";

    for (var row in result) {
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

    Navigator.pushReplacementNamed(context, '/home', arguments: rooms);
  }

  @override
  void initState() {
    super.initState();
    setupConnectionToBroker();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(52, 192, 209, 1),
      child: Center(
        child: SpinKitFoldingCube(
          color: Colors.white
        ),
      ),
    );
  }
}
