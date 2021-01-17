enum SensorTypes {
  light,
  engine,
  detector
}

class Room {
  String name;
  String iconName;
  String prefix;
  List<SensorTypes> sensors;

  Room({this.name, this.iconName, this.prefix, this.sensors});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'iconName': iconName,
      'prefix': prefix,
      'sensors': sensors,
    };
  }
}