import 'Sensor.dart';

class Room {
  String name;
  String iconName;
  List<Sensor> sensors;

  Room({this.name, this.iconName, this.sensors});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'iconName': iconName,
      'sensors': sensors,
    };
  }
}